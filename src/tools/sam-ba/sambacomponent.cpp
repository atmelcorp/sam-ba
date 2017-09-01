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

#include "sambacomponent.h"
#include "sambaengine.h"

SambaComponent::SambaComponent(SambaEngine* engine)
	: m_engine(engine),
	  m_type(COMPONENT_UNKNOWN),
	  m_priority(0),
	  m_component(0)
{
}

SambaComponent::~SambaComponent()
{
	if (m_component)
		delete m_component;
}

bool SambaComponent::parseJson(const QJsonObject& obj)
{
	// parse JSON
	QString module = obj["module"].toString();
	QString module_version = obj["module_version"].toString();
	QString classname = obj["classname"].toString();
	QString type = obj["type"].toString();

	if (type == "connection")
		m_type = COMPONENT_CONNECTION;
	else if (type == "device")
		m_type = COMPONENT_DEVICE;
	else if (type == "board")
		m_type = COMPONENT_BOARD;

	// create component
	QString script = QString("import %1 %2; %3 { }")
			.arg(module).arg(module_version).arg(classname);
	m_component = new QQmlComponent(m_engine->qmlEngine());
	m_component->setData(script.toLocal8Bit(), QUrl());
	if (m_component->status() != QQmlComponent::Ready) {
		qCCritical(sambaLogQml) << script;
		qCCritical(sambaLogQml) << m_component->errorString();
		return false;
	}

	// create instance to get name and aliases
	QObject* object = newInstance();
	if (object) {
		m_name = object->property("name").toString();
		m_aliases = object->property("aliases").toStringList();
		m_priority = object->property("priority").toInt();
		delete object;
	}

	return true;
}

SambaComponentType SambaComponent::type() const
{
	return m_type;
}

const QString& SambaComponent::name() const
{
	return m_name;
}

const QStringList& SambaComponent::aliases() const
{
	return m_aliases;
}

qint32 SambaComponent::priority() const
{
	return m_priority;
}

QObject* SambaComponent::newInstance()
{
	QObject* object = m_component->beginCreate(m_engine->qmlEngine()->rootContext());
	if (object && m_type == COMPONENT_CONNECTION)
		object->setProperty("autoConnect", QVariant::fromValue(false));
	m_component->completeCreate();
	return object;
}
