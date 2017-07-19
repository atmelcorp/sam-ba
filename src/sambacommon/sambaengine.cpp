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

#include "sambaengine.h"
#include "sambametadata.h"
#include <QFile>

SambaEngine::SambaEngine(QObject *parent)
    : QObject(parent)
{
	m_qmlEngine.setOutputWarningsToStandardError(false);

	// forward signals from engine
	QObject::connect(&m_qmlEngine, &QQmlEngine::quit,
					 this, &SambaEngine::engineQuit, Qt::QueuedConnection);
	QObject::connect(&m_qmlEngine, &QQmlEngine::warnings,
					 this, &SambaEngine::engineWarnings);

	// add import path
	m_qmlEngine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");

	// create metadata object
	m_metadata = new SambaMetadata(this);
}

void SambaEngine::engineQuit()
{
	QCoreApplication::quit();
}

void SambaEngine::engineWarnings(const QList<QQmlError> &warnings)
{
	foreach(QQmlError warning, warnings)
	{
		QString url;
		if (warning.url().isLocalFile())
			url = warning.url().toLocalFile();
		else
			url = warning.url().toString();
		qCWarning(sambaLogQml, "%s:%d: %s", url.toLocal8Bit().constData(),
				  warning.line(), warning.description().toLocal8Bit().constData());
	}
}

SambaEngine::~SambaEngine()
{
	delete m_metadata;
}

QList<SambaComponent*> SambaEngine::listComponents(SambaComponentType type)
{
	return m_metadata->listComponents(type);
}

SambaComponent* SambaEngine::findComponent(SambaComponentType type, const QString& name)
{
	return m_metadata->findComponent(type, name);
}

QQmlEngine* SambaEngine::qmlEngine()
{
	return &m_qmlEngine;
}

QObject* SambaEngine::createComponentInstance(QQmlComponent* component, QQmlContext* context)
{
	if (component->status() != QQmlComponent::Ready)
	{
		qCCritical(sambaLogCore) << component->errorString();
		return nullptr;
	}

	return component->create(context);
}

QObject* SambaEngine::createComponentInstance(const QString& script, QQmlContext* context)
{
	QQmlComponent component(&m_qmlEngine);
	component.setData(script.toLocal8Bit(), QUrl());
	return createComponentInstance(&component, context);
}

QObject* SambaEngine::createComponentInstance(const QUrl &url, QQmlContext* context)
{
	QQmlComponent component(&m_qmlEngine, url);
	return createComponentInstance(&component, context);
}

