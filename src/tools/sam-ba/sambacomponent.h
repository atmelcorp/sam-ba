/*
 * Copyright (c) 2017, Atmel Corporation.
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

#ifndef SAMBA_COMPONENT_H
#define SAMBA_COMPONENT_H

#include <QObject>
#include <QtQml>

enum SambaComponentType {
	COMPONENT_UNKNOWN,
	COMPONENT_CONNECTION,
	COMPONENT_DEVICE,
	COMPONENT_BOARD,
};

class SambaEngine;

class SambaComponent
{
public:
	SambaComponent(SambaEngine* engine);
	~SambaComponent();

	bool parseJson(const QJsonObject& obj);

	SambaComponentType type() const;
	const QString& name() const;
	const QStringList& aliases() const;
	qint32 priority() const;

	QObject* newInstance();

private:
	SambaEngine* m_engine;
	SambaComponentType m_type;
	QString m_name;
	QStringList m_aliases;
	qint32 m_priority;
	QQmlComponent* m_component;
};

#endif // SAMBA_COMPONENT_H
