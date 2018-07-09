/*
 * Copyright (c) 2015-2016, Atmel Corporation.
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

#include "sambaconnectionserialhelper.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QStringList>
#include "xmodemhelper.h"

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
	  m_baudRate(0),
	  m_mailboxAddr(0),
	  m_cmdCode(~0),
	  m_maxChunkSize(16384)
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

qint32 SambaConnectionSerialHelper::baudRate() const
{
	return m_baudRate;
}

void SambaConnectionSerialHelper::setBaudRate(qint32 baudRate)
{
	if (m_baudRate != baudRate)
	{
		m_baudRate = baudRate;
		emit baudRateChanged();
	}
}

quint32 SambaConnectionSerialHelper::mailboxAddr() const
{
	return m_mailboxAddr;
}

void SambaConnectionSerialHelper::setMailboxAddr(quint32 mailboxAddr)
{
	if (m_mailboxAddr != mailboxAddr)
	{
		m_mailboxAddr = mailboxAddr;
		emit mailboxAddrChanged();
	}
}

quint32 SambaConnectionSerialHelper::cmdCode() const
{
	return m_cmdCode;
}

void SambaConnectionSerialHelper::setCmdCode(quint32 cmdCode)
{
	if (m_cmdCode != cmdCode)
	{
		m_cmdCode = cmdCode;
		emit cmdCodeChanged();
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

void SambaConnectionSerialHelper::open(qint32 maxChunkSize)
{
	m_maxChunkSize = maxChunkSize;

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
		readSerial(255);

		// switch to binary mode
		writeSerial(QString("N#"));
		QString resp(QString::fromLatin1(readSerial(2)));
		if (resp == "\n\r")
		{
			emit connectionOpened(m_at91);
		}
		else
		{
			if (resp == "CACK,ffffffff,00000000#")
			{
				emit connectionFailed(
						QString().sprintf(
							"Cannot communicate with monitor on port '%s' because chip is in secure mode",
							port().toLocal8Bit().constData()));
			}
			else
			{
				emit connectionFailed(
						QString().sprintf(
							"Could not switch monitor on port '%s' to binary mode",
							port().toLocal8Bit().constData()));
			}
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

QByteArray SambaConnectionSerialHelper::readSerial(int len, int timeout)
{
	QByteArray resp;
	QElapsedTimer timer;

	/* timeout=0 -> default timeout, timeout<0 -> no timeout */
	if (timeout == 0)
		timeout = len < 1000 ? 100 : (len / 10);

	timer.start();
	do {
		int remaining = 0;
		if (timeout > 0)
		{
			remaining = timeout - timer.elapsed();
			if (remaining < 0)
				break;
		}
		m_serial.waitForReadyRead(10);
		int available = (int)m_serial.bytesAvailable();
		if (available > 0)
			resp.append(m_serial.read(qMin(available, len - resp.length())));
	} while (resp.length() < len);

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

QVariant SambaConnectionSerialHelper::readu8(quint32 address, int timeout)
{
	if (!m_serial.isOpen())
		return QVariant();

	writeSerial(QString().sprintf("o%x,#", address));

	QByteArray resp = readSerial(1, timeout);
	quint8 value = (quint8)resp[0];
	return QVariant(value);
}

QVariant SambaConnectionSerialHelper::readu16(quint32 address, int timeout)
{
	if (!m_serial.isOpen())
		return QVariant();

	writeSerial(QString().sprintf("h%x,#", address));

	QByteArray resp = readSerial(2, timeout);
	quint16 value = (((quint8)resp[1]) << 8) + ((quint8)resp[0]);
	return QVariant(value);
}

QVariant SambaConnectionSerialHelper::readu32(quint32 address, int timeout)
{
	if (!m_serial.isOpen())
		return false;

	writeSerial(QString().sprintf("w%x,#", address));

	QByteArray resp = readSerial(4, timeout);
	quint32 value = (((quint8)resp[3]) << 24) + (((quint8)resp[2]) << 16) +
			(((quint8)resp[1]) << 8) + ((quint8)resp[0]);
	return QVariant(value);
}

QByteArray SambaConnectionSerialHelper::read(quint32 address, int length, int timeout)
{
	if (!m_serial.isOpen() || length == 0)
		return QByteArray();

	QByteArray data;
	QElapsedTimer timer;
	int default_timeout;

	if (m_at91) {
		/* default timeout on USB (0.1ms/byte) */
		default_timeout = length < 1000 ? 100 : (length / 10);
	} else {
		/* default timeout on UART (10ms/byte) */
		default_timeout = length < 100 ? 1000 : length * 10;
	}
	if (timeout > 0 && timeout < default_timeout)
		timeout = default_timeout;

	int offset = 0;
	timer.start();
	while (length > 0)
	{
		int remaining = 0;
		if (timeout > 0)
		{
			remaining = timeout - timer.elapsed();
			if (remaining < 0) {
				qCDebug(sambaLogConnSerial).noquote().nospace() << "SERIAL<< [read timeout]";
				break;
			}
		}
		int chunkSize = length > m_maxChunkSize ? m_maxChunkSize : length;
		if (m_at91 && (chunkSize & 63) == 0)
			chunkSize--;
		writeSerial(QString().sprintf("R%x,%x#", address + offset, chunkSize));
		if (m_at91) {
			data.append(readSerial(chunkSize, remaining));
		} else {
			XmodemHelper xmodem(m_serial);
			QByteArray received(xmodem.receive(chunkSize));
			data.append(received);
			chunkSize = received.size();
		}
		offset += chunkSize;
		length -= chunkSize;
	}

	return data;
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

bool SambaConnectionSerialHelper::write(quint32 address, const QByteArray& data)
{
	if (!m_serial.isOpen())
		return false;

	int length = data.length();
	int offset = 0;
	while (length > 0)
	{
		int chunkSize = length > m_maxChunkSize ? m_maxChunkSize : length;
		writeSerial(QString().sprintf("S%x,%x#", address + offset, chunkSize));
		if (m_at91) {
			writeSerial(data.mid(offset, chunkSize));
		} else {
			XmodemHelper xmodem(m_serial);
			if (!xmodem.send(data.mid(offset, chunkSize)))
				return false;
		}
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

bool SambaConnectionSerialHelper::waitForMonitor(int timeout)
{
	if (!m_serial.isOpen())
		return false;

	if (m_at91) {
		QVariant value = readu32(m_mailboxAddr, timeout);
		bool ok = false;
		quint32 ack = value.toUInt(&ok);
		return (ok && (ack == ~m_cmdCode));
	} else {
		QByteArray response = readSerial(1, timeout);
		return (response.size() == 1) && (response.at(0) == 6);
	}
}
