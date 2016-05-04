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

#include <sambaconnection.h>
#include <QLoggingCategory>
#include <QSerialPort>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnSerial)

class Q_DECL_EXPORT SambaConnectionSerialHelper : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString port READ port WRITE setPort NOTIFY portChanged)
	Q_PROPERTY(quint32 baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)

public:
	SambaConnectionSerialHelper(QQuickItem *parent = 0);
	~SambaConnectionSerialHelper();

	QString port() const;
	void setPort(const QString& port);

	quint32 baudRate() const;
	void setBaudRate(quint32 baudRate);

	Q_INVOKABLE QStringList availablePorts();

	Q_INVOKABLE void open();
	Q_INVOKABLE void close();

	Q_INVOKABLE QVariant readu8(quint32 address);
	Q_INVOKABLE QVariant readu16(quint32 address);
	Q_INVOKABLE QVariant readu32(quint32 address);
	Q_INVOKABLE SambaByteArray* read(quint32 address, unsigned length);

	Q_INVOKABLE bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE bool write(quint32 address, SambaByteArray *data);

	Q_INVOKABLE bool go(quint32 address);

signals:
	void portChanged();
	void baudRateChanged();
	void connectionOpened(bool at91);
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	void writeSerial(const QString &str);
	void writeSerial(const QByteArray &data);
	QByteArray readAllSerial();

private:
	bool m_at91;
	QString m_port;
	quint32 m_baudRate;
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
		qmlRegisterType<SambaConnectionSerialHelper>(uri, 3, 0, "SerialConnectionHelper");
	}
};

#endif // SAMBA_CONNECTION_SERIAL_H
