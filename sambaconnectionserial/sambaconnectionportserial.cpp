#include "sambaconnectionportserial.h"
#include <QDebug>
#include <QThread>
#include <QSerialPortInfo>

#define MAX_BUF_SIZE (16*1024)

SambaConnectionPortSerial::SambaConnectionPortSerial(QObject* parent, const QSerialPortInfo &info, bool at91)
    : SambaConnectionPort(parent), m_at91(at91)
{
	m_serial.setPort(info);
	if (at91)
		m_serial.setBaudRate(921600);
	else
        m_serial.setBaudRate(115200);
	m_serial.setDataBits(QSerialPort::Data8);
    m_serial.setParity(QSerialPort::NoParity);
    m_serial.setStopBits(QSerialPort::OneStop);
	m_serial.setFlowControl(QSerialPort::NoFlowControl);

	m_tag = info.portName();
	m_name = info.description();
	if (info.description().isEmpty())
		m_name = info.portName();
	else
		m_name = info.portName() + " (" + info.description() + ")";
	m_description = m_name;
}

SambaConnectionPortSerial::~SambaConnectionPortSerial()
{
	disconnect();
}

qint32 SambaConnectionPortSerial::baudRate()
{
    return m_serial.baudRate();
}

void SambaConnectionPortSerial::setBaudRate(qint32 baudRate)
{
    m_serial.setBaudRate(baudRate);
}

bool SambaConnectionPortSerial::connect()
{
    qDebug("Connecting to %s", description().toLatin1().constData());

    bool ok = m_serial.open(QIODevice::ReadWrite);
	if (ok)
	{
		writeSerial(QString("N#"));
		readAllSerial();
	}
	return ok;
}

void SambaConnectionPortSerial::writeSerial(const QString &str)
{
    if (traceLevel() > 0)
        qDebug().noquote().nospace() << "SERIAL<<" << str;

	QByteArray data = str.toLatin1();
	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(100);
}

void SambaConnectionPortSerial::writeSerial(const QByteArray &data)
{
    if (traceLevel() > 0)
        qDebug().noquote().nospace() << "SERIAL<<" << data.toHex();

	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(100);
}

QByteArray SambaConnectionPortSerial::readAllSerial()
{
	QByteArray resp;
	while (true)
	{
		m_serial.waitForReadyRead(100);
		if (m_serial.bytesAvailable() == 0)
			break;
		resp.append(m_serial.readAll());
	};

    if (traceLevel() > 0)
        qDebug().noquote().nospace() << "SERIAL>>" << resp.toHex();

    return resp;
}

void SambaConnectionPortSerial::disconnect()
{
	if (m_serial.isOpen())
		m_serial.close();
}

quint8 SambaConnectionPortSerial::readu8(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("o%x,#", address));

	QByteArray resp = readAllSerial();
	return (quint8)resp[0];
}

quint16 SambaConnectionPortSerial::readu16(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("h%x,#", address));

	QByteArray resp = readAllSerial();
	return (((quint8)resp[1]) << 8) +
			((quint8)resp[0]);
}

quint32 SambaConnectionPortSerial::readu32(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("w%x,#", address));

	QByteArray resp = readAllSerial();
	return (((quint8)resp[3]) << 24) +
			(((quint8)resp[2]) << 16) +
			(((quint8)resp[1]) << 8) +
			((quint8)resp[0]);
}

QByteArray SambaConnectionPortSerial::read(quint32 address, int length)
{
	if (!m_serial.isOpen())
		return QByteArray();

	writeSerial(QString().sprintf("R%x,%x#", address, length));
	return readAllSerial();
}

bool SambaConnectionPortSerial::writeu8(quint32 address, quint8 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("O%x,%02x#", address, data));
	return true;
}

bool SambaConnectionPortSerial::writeu16(quint32 address, quint16 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("H%x,%04x#", address, data));
	return true;
}

bool SambaConnectionPortSerial::writeu32(quint32 address, quint32 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("W%x,%08x#", address, data));
	return true;
}

bool SambaConnectionPortSerial::write(quint32 address, const QByteArray &data)
{
	if (!m_serial.isOpen())
		return false;

	int length = data.length();
	int offset = 0;
	while (length > 0)
	{
		int chunkSize = length > MAX_BUF_SIZE ? MAX_BUF_SIZE : length;
		writeSerial(QString().sprintf("S%x,%x#", address + offset, chunkSize));
		writeSerial(data.mid(offset, chunkSize));
		offset += chunkSize;
		length -= chunkSize;
	}

	return true;
}

bool SambaConnectionPortSerial::go(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("G%x#", address));

	return true;
}

quint32 SambaConnectionPortSerial::appletCommType()
{
	if (m_at91)
		return SambaApplet::CommUSB;
	else
		return SambaApplet::CommSerial;
}
