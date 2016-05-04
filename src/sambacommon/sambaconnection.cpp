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

#include "sambaconnection.h"
#include <QStringList>

SambaConnection::SambaConnection(QQuickItem* parent)
	: QQuickItem(parent)
{
}

SambaConnection::~SambaConnection()
{
}

QString SambaConnection::name() const
{
	return m_name;
}

void SambaConnection::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QStringList SambaConnection::aliases() const
{
	return m_aliases;
}

void SambaConnection::setAliases(const QStringList& aliases)
{
	m_aliases = aliases;
	emit aliasesChanged();
}

quint32 SambaConnection::appletConnectionType() const
{
	return m_appletConnectionType;
}

void SambaConnection::setAppletConnectionType(quint32 appletConnectionType)
{
	m_appletConnectionType = appletConnectionType;
	emit appletConnectionTypeChanged();
}

QVariant SambaConnection::applet() const
{
	return m_applet;
}

void SambaConnection::setApplet(QVariant applet)
{
	if (m_applet != applet) {
		m_applet = applet;
		emit appletChanged();
	}
}
