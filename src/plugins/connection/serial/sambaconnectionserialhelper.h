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

#ifndef SAMBA_CONNECTION_SERIAL_H
#define SAMBA_CONNECTION_SERIAL_H

#include <QByteArray>
#include <QLoggingCategory>
#include <QSerialPort>
#include <QtQml>
#include <QtQuick/QQuickItem>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnSerial)

class Q_DECL_EXPORT SambaConnectionSerialHelper : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString port READ port WRITE setPort NOTIFY portChanged)
	Q_PROPERTY(qint32 baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)
	Q_PROPERTY(quint32 mailboxAddr READ mailboxAddr WRITE setMailboxAddr NOTIFY mailboxAddrChanged)
	Q_PROPERTY(quint32 cmdCode READ cmdCode WRITE setCmdCode NOTIFY cmdCodeChanged)

public:
	SambaConnectionSerialHelper(QQuickItem *parent = 0);
	~SambaConnectionSerialHelper();

	QString port() const;
	void setPort(const QString& port);

	qint32 baudRate() const;
	void setBaudRate(qint32 baudRate);

	quint32 mailboxAddr() const;
	void setMailboxAddr(quint32 mailboxAddr);

	quint32 cmdCode() const;
	void setCmdCode(quint32 cmdCode);

	Q_INVOKABLE QStringList availablePorts();

	Q_INVOKABLE void open(qint32 maxChunkSize = 16384);
	Q_INVOKABLE void close();

	Q_INVOKABLE QVariant readu8(quint32 address, int timeout);
	Q_INVOKABLE QVariant readu16(quint32 address, int timeout);
	Q_INVOKABLE QVariant readu32(quint32 address, int timeout);
	Q_INVOKABLE QByteArray read(quint32 address, int length, int timeout);

	Q_INVOKABLE bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE bool write(quint32 address, const QByteArray& data);

	Q_INVOKABLE bool go(quint32 address);
	Q_INVOKABLE bool waitForMonitor(int timeout);

signals:
	void portChanged();
	void baudRateChanged();
	void mailboxAddrChanged();
	void cmdCodeChanged();
	void connectionOpened(bool at91);
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	void writeSerial(const QString &str);
	void writeSerial(const QByteArray &data);
	QByteArray readSerial(int len = 0, int timeout = 100);

private:
	bool m_at91;
	QString m_port;
	qint32 m_baudRate;
	quint32 m_mailboxAddr;
	quint32 m_cmdCode;
	qint32 m_maxChunkSize;
	QSerialPort m_serial;
};

class Q_DECL_EXPORT SambaConnectionSerialPlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri)
	{
		Q_ASSERT(uri == QLatin1String("SAMBA.Connection.Serial"));
		qmlRegisterType<SambaConnectionSerialHelper>(uri, 3, 2, "SerialConnectionHelper");
	}
};

#endif // SAMBA_CONNECTION_SERIAL_H
