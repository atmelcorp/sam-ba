#include "xmodemhelper.h"

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

bool XmodemHelper::readByte(uint8_t* data)
{
	char c;

	m_serial.waitForReadyRead(100);
	if (m_serial.getChar(&c)) {
		if (data)
			*data = *(uint8_t*)&c;
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
	uint16_t crc = 0;
	int chunk = length - offset;

	if (chunk > XMODEM_DATALEN)
		chunk = XMODEM_DATALEN;

	writeByte(XMODEM_XOH);
	writeByte(seqno);
	writeByte(~seqno);
	for (int i = 0; i < XMODEM_DATALEN; i++)
	{
		uint8_t b = i < chunk ? *(uint8_t*)(data + offset + i) : 0x00;
		updateCRC(crc, b);
		writeByte(b);
	}
	writeByte((uint8_t)(crc >> 8));
	writeByte((uint8_t)(crc & 0xff));

	return chunk;
}

QByteArray XmodemHelper::getPacket(int length, uint8_t seqno)
{
	QByteArray data;
	uint8_t seq, nseq, b;
	uint16_t crc = 0;
	uint16_t computed_crc = 0;

	if (length > XMODEM_DATALEN)
		length = XMODEM_DATALEN;

	readByte(&seq);
	readByte(&nseq);

	for (int i = 0; i < XMODEM_DATALEN; i++)
	{
		readByte(&b);
		updateCRC(computed_crc, b);
		if (i < length)
			data.append(b);
	}

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
	return data;
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
		if (!readByte(&b))
			if (!readByte(&b))
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
