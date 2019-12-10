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

#ifndef SAMBA_CONNECTION_SECURE_H
#define SAMBA_CONNECTION_SECURE_H

#include <QByteArray>
#include <QLoggingCategory>
#include <QSerialPort>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SecureMonitorReply;

class Q_DECL_EXPORT SambaConnectionSecureHelper : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString port READ port WRITE setPort NOTIFY portChanged)
	Q_PROPERTY(qint32 baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)
	Q_PROPERTY(qint32 verboseLevel READ verboseLevel WRITE setVerboseLevel NOTIFY verboseLevelChanged)
	Q_PROPERTY(qint32 status READ status)

public:
	SambaConnectionSecureHelper(QQuickItem *parent = 0);
	~SambaConnectionSecureHelper();

	QString port() const;
	void setPort(const QString& port);

	qint32 baudRate() const;
	void setBaudRate(qint32 baudRate);

	qint32 verboseLevel() const;
	void setVerboseLevel(qint32 verboseLevel);

	Q_INVOKABLE QStringList availablePorts();

	Q_INVOKABLE void open();
	Q_INVOKABLE void close();

	Q_INVOKABLE qint32 status() const { return m_status; }
	Q_INVOKABLE bool executeWriteCommand(const QString& command, const QByteArray& data);
	Q_INVOKABLE QByteArray executeReadCommand(const QString& command, quint32 length, int timeout);
	Q_INVOKABLE bool go();
	Q_INVOKABLE bool waitForMonitor(int timeout);
	Q_INVOKABLE QByteArray version();

signals:
	void portChanged();
	void baudRateChanged();
	void verboseLevelChanged();
	void connectionOpened(bool at91);
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	void writeSerial(const QByteArray &data);
	QByteArray readSerial(int len, int timeout);
	void writeCommand(const QString &str);
	bool readReply(QString& verb, qint32& status, quint32& length, int timeout);
	bool writeData(const QByteArray &data);
	QByteArray readData(quint32 length, int timeout);
	bool waitForApplet(int timeout);

private:
	bool m_at91;
	bool m_usb_zlp_quirk;
	QString m_port;
	qint32 m_baudRate;
	qint32 m_verboseLevel;
	QSerialPort m_serial;
	qint32 m_status;
	QLoggingCategory m_sambaLogConnSecure;
};

class Q_DECL_EXPORT SambaConnectionSecurePlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri)
	{
		Q_ASSERT(uri == QLatin1String("SAMBA.Connection.Secure"));
		qmlRegisterType<SambaConnectionSecureHelper>(uri, 3, 2, "SecureConnectionHelper");
	}
};

#endif // SAMBA_CONNECTION_SECURE_H
