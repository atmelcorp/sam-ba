#ifndef XMODEMHELPER_H
#define XMODEMHELPER_H

#include <QByteArray>
#include <QElapsedTimer>
#include <QSerialPort>

class XmodemHelper
{
public:
	XmodemHelper(QSerialPort& serial);

	QByteArray receive(int length);
	bool send(const QByteArray &data);

private:
	void updateCRC(uint16_t &crc, const uint8_t data);
	bool readData(uint8_t* data, int length);
	bool readByte(uint8_t* data);
	bool writeData(uint8_t* data, int length);
	bool writeByte(uint8_t data);
	int putPacket(const char* data, int offset, int length, uint8_t seqno);
	QByteArray getPacket(int length, uint8_t seqno);

private:
	QSerialPort& m_serial;
};

#endif // XMODEMHELPER_H
