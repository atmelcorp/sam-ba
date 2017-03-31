#ifndef XMODEMHELPER_H
#define XMODEMHELPER_H

#include <QElapsedTimer>
#include <QSerialPort>
#include <sambabytearray.h>

class XmodemHelper
{
public:
	XmodemHelper(QSerialPort& serial);

	QByteArray receive(int length);
	bool send(const QByteArray &data);

private:
	void updateCRC(uint16_t &crc, const uint8_t data);
	bool readByte(uint8_t* data);
	bool writeByte(uint8_t data);
	int putPacket(const char* data, int offset, int length, uint8_t seqno);
	QByteArray getPacket(int length, uint8_t seqno);

private:
	QSerialPort& m_serial;
};

#endif // XMODEMHELPER_H
