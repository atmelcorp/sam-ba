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

#ifndef SAMBA_CONNECTION_H
#define SAMBA_CONNECTION_H

#include <sambacommon.h>
#include <sambabytearray.h>
#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SAMBACOMMONSHARED_EXPORT SambaConnection : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QStringList aliases READ aliases WRITE setAliases NOTIFY aliasesChanged)
	Q_PROPERTY(quint32 appletConnectionType READ appletConnectionType WRITE setAppletConnectionType NOTIFY appletConnectionTypeChanged)
	Q_PROPERTY(QVariant applet READ applet WRITE setApplet NOTIFY appletChanged)
	Q_ENUMS(ConnectionType)

public:
	enum ConnectionType {
		USB = 0x00000000,
		Serial = 0x00000001,
		JTAG = 0x00000002,
	};

	SambaConnection(QQuickItem *parent = 0);
	virtual ~SambaConnection();

	QString name() const;
	void setName(const QString& name);

	QStringList aliases() const;
	void setAliases(const QStringList& aliases);

	quint32 appletConnectionType() const;
	void setAppletConnectionType(quint32 appletConnectionType);

	QVariant applet() const;
	void setApplet(QVariant applet);

signals:
	void nameChanged();
	void aliasesChanged();
	void appletConnectionTypeChanged();
	void appletChanged();

private:
	QString m_name;
	QStringList m_aliases;
	quint32 m_appletConnectionType;
	QVariant m_applet;
};

#endif // SAMBA_CONNECTION_H
