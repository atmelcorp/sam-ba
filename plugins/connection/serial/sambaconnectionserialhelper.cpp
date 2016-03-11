#include "sambaconnectionserialhelper.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QStringList>

#define MAX_BUF_SIZE (32*1024)

#define ATMEL_USB_VID 0x03eb
#define SAMBA_USB_PID 0x6124

Q_LOGGING_CATEGORY(sambaLogConnSerial, "samba.connserial")

static bool serial_is_at91(const QSerialPortInfo& info)
{
	return info.hasVendorIdentifier()
			&& info.vendorIdentifier() == ATMEL_USB_VID
			&& info.hasProductIdentifier()
			&& info.productIdentifier() == SAMBA_USB_PID;
}

SambaConnectionSerialHelper::SambaConnectionSerialHelper(QQuickItem* parent)
	: QQuickItem(parent),
      m_port(""),
	  m_baudRate(0)
{
}

SambaConnectionSerialHelper::~SambaConnectionSerialHelper()
{
	close();
}

QString SambaConnectionSerialHelper::port() const
{
	return m_port;
}

void SambaConnectionSerialHelper::setPort(const QString& port)
{
	if (m_port != port)
	{
		m_port = port;
		emit portChanged();
	}
}

quint32 SambaConnectionSerialHelper::baudRate() const
{
	return m_baudRate;
}

void SambaConnectionSerialHelper::setBaudRate(quint32 baudRate)
{
	if (m_baudRate != baudRate)
	{
		m_baudRate = baudRate;
		emit baudRateChanged();
	}
}

QStringList SambaConnectionSerialHelper::availablePorts()
{
	QStringList list_at91, list_other;
	QSerialPortInfo info;
	foreach (info, QSerialPortInfo::availablePorts()) {
		if (serial_is_at91(info))
			list_at91.append(info.portName());
		else
			list_other.append(info.portName());
	}
	return list_at91 + list_other;
}

void SambaConnectionSerialHelper::open()
{
	if (port().isEmpty())
	{
		QStringList ports = availablePorts();
		if (ports.isEmpty())
		{
			emit connectionFailed("No serial ports found");
			return;
		}

		setPort(ports.at(0));
	}

	QSerialPortInfo info(port());
	if (!info.isValid())
	{
		emit connectionFailed(
				QString().sprintf("Cannot open invalid port '%s'",
					port().toLocal8Bit().constData()));
		return;
	}

	m_at91 = serial_is_at91(info);

	m_serial.setPort(info);
	if (m_baudRate <= 0)
		m_baudRate = m_at91 ? 921600 : 115200;
	m_serial.setBaudRate(m_baudRate);
	m_serial.setDataBits(QSerialPort::Data8);
	m_serial.setParity(QSerialPort::NoParity);
	m_serial.setStopBits(QSerialPort::OneStop);
	m_serial.setFlowControl(QSerialPort::NoFlowControl);

	qCInfo(sambaLogConnSerial, "Opening serial port '%s'",
			port().toLocal8Bit().constData());

	if (m_serial.open(QIODevice::ReadWrite))
	{
		// resync in case some data was already sent to monitor:
		// send a single '#' and ignore response
		writeSerial(QString("#"));
		readAllSerial();

		// switch to binary mode
		writeSerial(QString("N#"));
		QByteArray resp = readAllSerial();
		if (resp.length() == 2 && resp[0] == '\n' && resp[1] == '\r')
		{
			emit connectionOpened(m_at91);
		}
		else
		{
			emit connectionFailed(
					QString().sprintf(
						"Could not switch monitor on port '%s' to binary mode",
						port().toLocal8Bit().constData()));
		}
	}
	else
	{
		emit connectionFailed(
				QString().sprintf("Could not open serial port '%s': %s",
					port().toLocal8Bit().constData(),
					m_serial.errorString().toLocal8Bit().constData()));
	}
}

void SambaConnectionSerialHelper::writeSerial(const QString &str)
{
	qCDebug(sambaLogConnSerial).noquote().nospace() << "SERIAL<<" << str;

	QByteArray data = str.toLocal8Bit();
	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(10);
}

void SambaConnectionSerialHelper::writeSerial(const QByteArray &data)
{
	qCDebug(sambaLogConnSerial).noquote().nospace() << "SERIAL<<" << data.toHex();

	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(10);
}

QByteArray SambaConnectionSerialHelper::readAllSerial()
{
	QByteArray resp;
	while (true)
	{
		m_serial.waitForReadyRead(10);
		if (m_serial.bytesAvailable() == 0)
			break;
		resp.append(m_serial.readAll());
	};

	qCDebug(sambaLogConnSerial).noquote().nospace() << "SERIAL>>" << resp.toHex();

	return resp;
}

void SambaConnectionSerialHelper::close()
{
	if (m_serial.isOpen())
	{
		m_serial.close();
		emit connectionClosed();
	}
}

QVariant SambaConnectionSerialHelper::readu8(quint32 address)
{
	if (!m_serial.isOpen())
		return QVariant();

	writeSerial(QString().sprintf("o%x,#", address));

	QByteArray resp = readAllSerial();
	quint8 value = (quint8)resp[0];
	return QVariant(value);
}

QVariant SambaConnectionSerialHelper::readu16(quint32 address)
{
	if (!m_serial.isOpen())
		return QVariant();

	writeSerial(QString().sprintf("h%x,#", address));

	QByteArray resp = readAllSerial();
	quint16 value = (((quint8)resp[1]) << 8) + ((quint8)resp[0]);
	return QVariant(value);
}

QVariant SambaConnectionSerialHelper::readu32(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("w%x,#", address));

	QByteArray resp = readAllSerial();
	quint32 value = (((quint8)resp[3]) << 24) + (((quint8)resp[2]) << 16) +
			(((quint8)resp[1]) << 8) + ((quint8)resp[0]);
	return QVariant(value);
}

SambaByteArray *SambaConnectionSerialHelper::read(quint32 address, unsigned length)
{
	if (!m_serial.isOpen() || length == 0)
		return new SambaByteArray();

	QByteArray data;
	int offset = 0;
	while (length > 0)
	{
		int chunkSize = length > MAX_BUF_SIZE ? MAX_BUF_SIZE : length;
		if ((chunkSize & 63) == 0)
			chunkSize--;
		writeSerial(QString().sprintf("R%x,%x#", address + offset, chunkSize));
		data.append(readAllSerial());
		offset += chunkSize;
		length -= chunkSize;
	}

	return new SambaByteArray(data);
}

bool SambaConnectionSerialHelper::writeu8(quint32 address, quint8 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("O%x,%02x#", address, data));
	return true;
}

bool SambaConnectionSerialHelper::writeu16(quint32 address, quint16 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("H%x,%04x#", address, data));
	return true;
}

bool SambaConnectionSerialHelper::writeu32(quint32 address, quint32 data)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("W%x,%08x#", address, data));
	return true;
}

bool SambaConnectionSerialHelper::write(quint32 address, SambaByteArray *data)
{
	if (!m_serial.isOpen())
		return false;

	int length = data->constData().length();
	int offset = 0;
	while (length > 0)
	{
		int chunkSize = length > MAX_BUF_SIZE ? MAX_BUF_SIZE : length;
		writeSerial(QString().sprintf("S%x,%x#", address + offset, chunkSize));
		writeSerial(data->constData().mid(offset, chunkSize));
		offset += chunkSize;
		length -= chunkSize;
	}

	return true;
}

bool SambaConnectionSerialHelper::go(quint32 address)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("G%x#", address));

	return true;
}
