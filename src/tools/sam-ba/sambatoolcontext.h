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

#ifndef SAMBA_TOOL_CONTEXT_H
#define SAMBA_TOOL_CONTEXT_H

#include <QObject>
#include <QVariant>

class SambaToolContext : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QVariant port READ port NOTIFY portChanged)
	Q_PROPERTY(QVariant appletName READ appletName NOTIFY appletNameChanged)
	Q_PROPERTY(QVariant commands READ commands NOTIFY commandsChanged)

public:
	SambaToolContext(QObject* parent = 0)
	    : QObject(parent),
	      m_commands(QVariantList())
	{
	}

	QVariant port() const {
		return m_port;
	}

	void setPort(QVariant port)
	{
		m_port = port;
		emit portChanged();
	}

	QVariant appletName() const {
		return m_appletName;
	}

	void setAppletName(QVariant appletName)
	{
		m_appletName = appletName;
		emit appletNameChanged();
	}

	QVariant commands() const {
		return m_commands;
	}

	void setCommands(const QVariant& commands)
	{
		m_commands = commands;
		emit commandsChanged();
	}

	Q_INVOKABLE void error(const QString& message)
	{
		emit toolError(message);
	}

signals:
	void portChanged();
	void appletNameChanged();
	void commandsChanged();
	void toolError(const QString& message);

private:
	QVariant m_port;
	QVariant m_appletName;
	QVariant m_commands;
};

#endif // SAMBA_TOOL_CONTEXT_H
