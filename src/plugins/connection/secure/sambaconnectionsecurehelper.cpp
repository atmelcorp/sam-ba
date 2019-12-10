/*
 * Copyright (c) 2018, Microchip Technology.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

#include "sambaconnectionsecurehelper.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QStringList>
#include "xmodemhelper.h"

#define ATMEL_USB_VID 0x03eb
#define SAMBA_USB_PID 0x6124

#define MAX_DISPLAY_BYTES 32

#define IS_ALIGNED(value, size) ((((quint32)(value)) & ((quint32)(size) - 1)) == 0)

#define SZ_USB_ENDPOINT 0x200

static bool serial_is_at91(const QSerialPortInfo& info)
{
	return info.hasVendorIdentifier()
			&& info.vendorIdentifier() == ATMEL_USB_VID
			&& info.hasProductIdentifier()
			&& info.productIdentifier() == SAMBA_USB_PID;
}

SambaConnectionSecureHelper::SambaConnectionSecureHelper(QQuickItem* parent)
	: QQuickItem(parent),
	  m_usb_zlp_quirk(false),
	  m_port(""),
	  m_baudRate(0),
	  m_verboseLevel(0),
	  m_status(0),
	  m_sambaLogConnSecure("samba.connsecure")
{

}

SambaConnectionSecureHelper::~SambaConnectionSecureHelper()
{
	close();
}

QString SambaConnectionSecureHelper::port() const
{
	return m_port;
}

void SambaConnectionSecureHelper::setPort(const QString& port)
{
	if (m_port != port)
	{
		m_port = port;
		emit portChanged();
	}
}

qint32 SambaConnectionSecureHelper::baudRate() const
{
	return m_baudRate;
}

void SambaConnectionSecureHelper::setBaudRate(qint32 baudRate)
{
	if (m_baudRate != baudRate)
	{
		m_baudRate = baudRate;
		emit baudRateChanged();
	}
}

qint32 SambaConnectionSecureHelper::verboseLevel() const
{
	return m_verboseLevel;
}

void SambaConnectionSecureHelper::setVerboseLevel(qint32 verboseLevel)
{
	if (m_verboseLevel != verboseLevel)
	{
		m_verboseLevel = verboseLevel;
		m_sambaLogConnSecure.setEnabled(QtDebugMsg, m_verboseLevel > 0);
		emit verboseLevelChanged();
	}
}

QStringList SambaConnectionSecureHelper::availablePorts()
{
	QStringList list_at91, list_other;
	QSerialPortInfo info;
	foreach (info, QSerialPortInfo::availablePorts())
	{
		if (serial_is_at91(info))
			list_at91.append(info.portName());
		else
			list_other.append(info.portName());
	}
	return list_at91 + list_other;
}

void SambaConnectionSecureHelper::open()
{
	if (port().isEmpty())
	{
		QStringList ports = availablePorts();
		if (ports.isEmpty())
		{
			emit connectionFailed("No USB ports found");
			return;
		}

		setPort(ports.at(0));
	}

	QSerialPortInfo info(port());
	if (!info.isValid())
	{
		emit connectionFailed(QString().sprintf("Cannot open invalid port '%s'",
		                      port().toLocal8Bit().constData()));
		return;
	}

	m_at91 = serial_is_at91(info);

	QObject &device = *qvariant_cast<QObject *>(parentItem()->property("device"));
	m_usb_zlp_quirk = device.property("usb_zlp_quirk").toBool();

	m_serial.setPort(info);
	if (m_baudRate <= 0)
		m_baudRate = m_at91 ? 921600 : 115200;
	m_serial.setBaudRate(m_baudRate);
	m_serial.setDataBits(QSerialPort::Data8);
	m_serial.setParity(QSerialPort::NoParity);
	m_serial.setStopBits(QSerialPort::OneStop);
	m_serial.setFlowControl(QSerialPort::NoFlowControl);

	qCInfo(m_sambaLogConnSecure, "Opening secure port '%s'",
			port().toLocal8Bit().constData());

	if (m_serial.open(QIODevice::ReadWrite))
	{
		emit connectionOpened(m_at91);
	}
	else
	{
		emit connectionFailed(QString().sprintf("Could not open secure port '%s': %s",
		                      port().toLocal8Bit().constData(),
		                      m_serial.errorString().toLocal8Bit().constData()));
	}
}

void SambaConnectionSecureHelper::writeCommand(const QString &str)
{
	qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE<<" << str;

	QByteArray data = str.toLocal8Bit();
	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(10);
}

void SambaConnectionSecureHelper::writeSerial(const QByteArray &data)
{
	m_serial.write(data.constData(), data.length());
	m_serial.waitForBytesWritten(10);
}

QByteArray SambaConnectionSecureHelper::readSerial(int len, int timeout)
{
	QByteArray resp;
	QElapsedTimer timer;

	/* timeout=0 -> default timeout, timeout<0 -> no timeout */
	if (timeout == 0)
		timeout = len < 1000 ? 100 : (len / 10);

	timer.start();
	do
	{
		int remaining = 0;
		if (timeout > 0)
		{
			remaining = timeout - timer.elapsed();
			if (remaining < 0)
			{
				qCDebug(m_sambaLogConnSecure).noquote().nospace() << "TIMEOUT";
				break;
			}
		}
		m_serial.waitForReadyRead(10);
		int available = m_serial.bytesAvailable();
		if (available > 0)
			resp.append(m_serial.read(qMin(available, len - resp.length())));
	} while (resp.length() < len);

	return resp;
}

void SambaConnectionSecureHelper::close()
{
	if (m_serial.isOpen())
	{
		m_serial.close();
		emit connectionClosed();
	}
}

bool SambaConnectionSecureHelper::readReply(QString& verb, qint32& status, quint32& length, int timeout)
{
	QString str = QString::fromLatin1(readData(23, timeout));
	if (str.length() == 23)
	{
		verb = str.mid(0, 4);
		status = str.mid(5, 8).toLong(0, 16);
		length = str.mid(14, 8).toULong(0, 16);
		qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE>>" << str;
		return true;
	}
	else
	{
		verb = "";
		status = -1;
		length = 0;
		return false;
	}
}

bool SambaConnectionSecureHelper::writeData(const QByteArray &data)
{
	if (m_verboseLevel > 2)
		qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE<<" << data.toHex();
	else if (m_verboseLevel == 2)
		qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE<<" << data.mid(0, qMin(data.size(), MAX_DISPLAY_BYTES)).toHex() << " [...] (" << data.size() << " bytes)";

	if (m_at91) {
		writeSerial(data);
		return true;
	}

	XmodemHelper xmodem(m_serial);
	return xmodem.send(data);
}

QByteArray SambaConnectionSecureHelper::readData(quint32 length, int timeout)
{
	QByteArray data;

	if (m_at91) {
		data = readSerial(length, timeout);
	} else {
		XmodemHelper xmodem(m_serial);
		data = xmodem.receive(length);
	}

	if (m_verboseLevel > 2)
		qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE>>" << data.toHex();
	else if (m_verboseLevel == 2)
		qCDebug(m_sambaLogConnSecure).noquote().nospace() << "SECURE>>" << data.mid(0, qMin(data.size(), MAX_DISPLAY_BYTES)).toHex() << " [...] (" << data.size() << " bytes)";

	return data;
}

bool SambaConnectionSecureHelper::waitForApplet(int timeout)
{
	if (!m_at91) {
		QByteArray response = readSerial(1, timeout);
		if (response.size() != 1 || response.at(0) != 6)
			return false;
	}

	return true;
}

bool SambaConnectionSecureHelper::executeWriteCommand(const QString& command, const QByteArray& data)
{
	quint32 remaining = data.length();
	quint32 offset = 0;
	int timeout = 10000;

	// send command
	writeCommand(QString().sprintf("%s,0,%x,0,1#", command.toLatin1().constData(), remaining));
	for (;;) {
		quint32 length;
		QString verb;

		if (!readReply(verb, m_status, length, timeout))
			return false;

		if (verb != "CACK" || m_status != 0 || length > remaining) {
			if (verb == "ASTA" && command == "SFIL") {
				int status;
				(void)readReply(verb, status, length, timeout);
			}

			return false;
		}

		if (!length)
			break;

		if (!writeData(data.mid(offset, length)))
			return false;

		if (command == "SFIL" && !waitForApplet(timeout))
			return false;

		offset += length;
		remaining -= length;
	}

	return (remaining == 0);
}

QByteArray SambaConnectionSecureHelper::executeReadCommand(const QString& command, quint32 length, int timeout)
{
	quint32 offset = 0;
	QByteArray data;

	do {
		quint32 len = length;
		QString verb;

		if (m_at91 && m_usb_zlp_quirk && len &&
		    IS_ALIGNED(len, SZ_USB_ENDPOINT))
			len--;

		writeCommand(QString().sprintf("%s,%x,%x,0,0#",
					       command.toLatin1().constData(),
					       offset, len));

		if (command == "RFIL" && !waitForApplet(timeout))
			return QByteArray();

		if (!readReply(verb, m_status, len, timeout))
			return QByteArray();

		if (verb != "CACK" || m_status != 0 || !len)
			return QByteArray();

		data.append(readData(len, timeout));

		offset += len;
		length -= len;
	} while (length);

	return data;
}

bool SambaConnectionSecureHelper::go()
{
	writeCommand("EAPP,0,0,0,0#");
	return true;
}

bool SambaConnectionSecureHelper::waitForMonitor(int timeout)
{
	quint32 length;
	QString verb;

	if (!waitForApplet(timeout))
		return false;

	if (!readReply(verb, m_status, length, timeout))
		return false;

	return (verb == "ASTA" && length == 0);
}

QByteArray SambaConnectionSecureHelper::version()
{
	int timeout = 10000;
	quint32 length;
	QString verb;

	writeCommand("RVER,0,0,0,0#");

	if (!readReply(verb, m_status, length, timeout))
		return QByteArray();

	if (verb != "SVER" || m_status != 0 || !length)
		return QByteArray();

	return readData(length, timeout);
}
