#include "xmodemhelper.h"
#include <QElapsedTimer>

/* Xmodem protocol constants */
#define XMODEM_XOH         0x01
#define XMODEM_EOT         0x04
#define XMODEM_ACK         0x06
#define XMODEM_NAK         0x15
#define XMODEM_CAN         0x18
#define XMODEM_ESC         0x1b
#define XMODEM_DATALEN     128
#define XMODEM_MAX_RETRIES 100

XmodemHelper::XmodemHelper(QSerialPort& serial)
    : m_serial(serial)
{

}

void XmodemHelper::updateCRC(uint16_t &crc, const uint8_t data)
{
	crc = crc ^ ((uint16_t)data << 8);
	for (int i = 0; i < 8; i++)
	{
		if (crc & 0x8000)
			crc = (crc << 1) ^ 0x1021;
		else
			crc <<= 1;
	}
}

bool XmodemHelper::readData(uint8_t* data, int length)
{
	QElapsedTimer timer;
	int timeout;
	int total = 0;

	/* timeout=0 -> default timeout, timeout<0 -> no timeout */
	timeout = length < 1000 ? 100 : (length / 10);

	timer.start();
	while (length > 0) {
		int remaining = 0;
		if (timeout > 0) {
			remaining = timeout - timer.elapsed();
			if (remaining < 0)
				return false;
		}
		m_serial.waitForReadyRead(10);
		int available = (int)m_serial.bytesAvailable();
		if (available > 0)
			available = m_serial.read((char*)data, length);
		data += available;
		length -= available;
		total += available;
	}

	return true;
}

bool XmodemHelper::readByte(uint8_t* data)
{
	QElapsedTimer timer;
	char b;

	timer.start();
	while (1) {
		if (timer.elapsed() > 500)
			return false;
		m_serial.waitForReadyRead(10);
		int available = (int)m_serial.bytesAvailable();
		if (available > 0 && m_serial.read(&b, 1) == 1) {
			if (data)
				*data = *(uint8_t*)&b;
			break;
		}
	}

	return true;
}

bool XmodemHelper::writeData(uint8_t* data, int length)
{
	if (m_serial.write((char*)data, length)) {
		m_serial.waitForBytesWritten(256);
		return true;
	}
	return false;
}

bool XmodemHelper::writeByte(uint8_t data)
{
	if (m_serial.putChar(*(char*)&data)) {
		m_serial.waitForBytesWritten(20);
		return true;
	}
	return false;
}

int XmodemHelper::putPacket(const char *data, int offset, int length, uint8_t seqno)
{
	uint8_t chunk_data[XMODEM_DATALEN];
	uint16_t crc = 0;
	int chunk = length - offset;

	if (chunk > XMODEM_DATALEN)
		chunk = XMODEM_DATALEN;

	memcpy(chunk_data, data + offset, chunk);
	if (chunk < XMODEM_DATALEN)
		memset(chunk_data + chunk, 0, XMODEM_DATALEN - chunk);

	writeByte(XMODEM_XOH);
	writeByte(seqno);
	writeByte(~seqno);
	writeData(chunk_data, XMODEM_DATALEN);
	for (int i = 0; i < XMODEM_DATALEN; i++)
		updateCRC(crc, chunk_data[i]);
	writeByte((uint8_t)(crc >> 8));
	writeByte((uint8_t)(crc & 0xff));

	return chunk;
}

QByteArray XmodemHelper::getPacket(int length, uint8_t seqno)
{
	uint8_t data[XMODEM_DATALEN];
	uint8_t seq, nseq, b;
	uint16_t crc = 0;
	uint16_t computed_crc = 0;

	if (length > XMODEM_DATALEN)
		length = XMODEM_DATALEN;

	readByte(&seq);
	readByte(&nseq);

	if (!readData(data, XMODEM_DATALEN))
		return QByteArray();

	for (int i = 0; i < XMODEM_DATALEN; i++)
		updateCRC(computed_crc, data[i]);

	readByte(&b);
	crc = (uint16_t)b << 8;
	readByte(&b);
	crc += (uint16_t)b;

	if ((crc != computed_crc) || (seq != seqno) || (nseq != (uint8_t)~seqno))
	{
		writeByte(XMODEM_CAN);
		return QByteArray();
	}

	writeByte(XMODEM_ACK);
	return QByteArray((char*)data, length);
}

QByteArray XmodemHelper::receive(int length)
{
	QByteArray data;
	uint8_t seqno = 1;
	uint8_t b;
	int retries;

	/* Startup synchronization */
	/* Continuously send 'C' until sender responds. */
	for (retries = 0; retries < XMODEM_MAX_RETRIES; retries++) {
		writeByte('C');
		if (m_serial.waitForReadyRead(500))
			break;
	}
	if (retries == XMODEM_MAX_RETRIES)
		return QByteArray();

	while (data.size() < length) {
		if (!readByte(&b))
			return QByteArray();

		switch(b) {
		case XMODEM_XOH: {
			/* incoming packet */
			QByteArray pktData = getPacket(length - data.size(), seqno);
			if (pktData.size() == 0)
				return QByteArray();

			data.append(pktData);
			seqno++;
			break;
		}
		case XMODEM_EOT:
			writeByte(XMODEM_ACK);
			break;
		case XMODEM_CAN:
		case XMODEM_ESC:
		default:
			return QByteArray();
		}
	}

	return data;
}

bool XmodemHelper::send(const QByteArray& data)
{
	uint8_t b, seqno = 1;
	int offset = 0;

	/* Startup synchronization */
	/* Wait to receive a NAK from receiver */
	while (true) {
		int i;
		for (i = 0; i < 16; i++) {
			if (readByte(&b))
				break;
		}
		if (i == 16)
			return false;
		if (b == XMODEM_NAK || b == 'C')
			break;
		else if (b == XMODEM_CAN)
			return false;
	}

	while (offset < data.size()) {
		/* send packet */
		int written = putPacket(data.constData(), offset, data.size(), seqno);

		/* get response from receiver */
		if (!readByte(&b))
			return false;

		switch(b) {
		case XMODEM_ACK:
			seqno++;
			offset += written;
			break;
		case XMODEM_NAK:
			break;
		case XMODEM_CAN:
		case XMODEM_EOT:
		default:
			return false;
		}
	}

	writeByte(XMODEM_EOT);
	readByte(0); /* Flush the ACK */

	return true;
}
