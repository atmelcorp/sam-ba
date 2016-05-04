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

#ifndef SAMBA_APPLET_COMMAND_H
#define SAMBA_APPLET_COMMAND_H

#include <sambacommon.h>
#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SAMBACOMMONSHARED_EXPORT SambaAppletCommand : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(quint32 code READ code WRITE setCode NOTIFY codeChanged)
	Q_PROPERTY(int timeout READ timeout WRITE setTimeout NOTIFY timeoutChanged)

public:
	explicit SambaAppletCommand(QQuickItem *parent = 0);

	QString name() const;
	void setName(const QString& name);

	quint32 code() const;
	void setCode(quint32 code);

	quint32 timeout() const;
	void setTimeout(quint32 timeout);

signals:
	void nameChanged();
	void codeChanged();
	void timeoutChanged();

private:
	QString m_name;
	quint32 m_code;
	quint32 m_timeout;
};

#endif // SAMBA_APPLET_COMMAND_H
