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

#include "sambaengine.h"
#include "sambametadata.h"
#include <QFile>

static bool componentCompare(const SambaComponent* c1, const SambaComponent* c2)
{
	qint32 prio1 = c1->priority();
	qint32 prio2 = c2->priority();
	if (prio1 == prio2)
		return c1->name() < c2->name();
	return prio1 < prio2;
}

static SambaComponent* findObject(const QList<SambaComponent*>& components, SambaComponentType type, const QString& name)
{
	foreach (SambaComponent* comp, components) {
		if (comp->type() != type)
			continue;
		if (!comp->name().compare(name, Qt::CaseInsensitive))
			return comp;
		if (comp->aliases().contains(name, Qt::CaseInsensitive))
			return comp;
	}

	return nullptr;
}

static void addObjectToList(QList<SambaComponent*>& list, SambaComponent* component)
{
	bool duplicate = false;

	if (findObject(list, component->type(), component->name()))
		duplicate = true;

	if (!duplicate) {
		QStringList aliases = component->aliases();
		foreach (QString alias, aliases) {
			if (findObject(list, component->type(), alias)) {
				duplicate = true;
				break;
			}
		}
	}

	if (duplicate) {
		delete component;
		return;
	}

	list << component;
}

SambaMetadata::SambaMetadata(SambaEngine* engine)
	: m_engine(engine), m_componentsLoaded(false)
{
}

SambaMetadata::~SambaMetadata()
{
	qDeleteAll(m_components);
	m_components.clear();
}

void SambaMetadata::loadMetadata(QString fileName)
{
	QFile file(fileName);

	qCDebug(sambaLogQml, "Loading metadata file '%s'.",
			fileName.toLocal8Bit().constData());

	if (!file.open(QIODevice::ReadOnly)) {
		qCCritical(sambaLogQml, "Couldn't open metadata file '%s'.",
				fileName.toLocal8Bit().constData());
		return;
	}

	QByteArray data = file.readAll();
	QJsonDocument doc(QJsonDocument::fromJson(data));
	SambaComponent* comp = new SambaComponent(m_engine);
	if (!comp->parseJson(doc.object())) {
		qCCritical(sambaLogQml, "Couldn't parse metadata file '%s'.",
				fileName.toLocal8Bit().constData());
		delete comp;
		return;
	}

	if (comp->type() == COMPONENT_UNKNOWN) {
		qCCritical(sambaLogQml, "Ignoring metadata file '%s': unknown metadata type or missing properties.",
				fileName.toLocal8Bit().constData());
		delete comp;
		return;
	}

	addObjectToList(m_components, comp);
}

void SambaMetadata::loadAllMetadata()
{
	if (m_componentsLoaded)
		return;

	QStringList paths;
	if (!qEnvironmentVariableIsEmpty("SAM_BA_METADATA_PATH")) {
	        const QByteArray envImportPath = qgetenv("SAM_BA_METADATA_PATH");
#if defined(Q_OS_WIN)
		QLatin1Char pathSep(';');
#else
		QLatin1Char pathSep(':');
#endif
		paths = QString::fromLatin1(envImportPath).split(pathSep, QString::SkipEmptyParts);
	}
	paths << (QCoreApplication::applicationDirPath() + "/metadata");

	foreach (QString path, paths) {
		QDir metadataDir(path);
		foreach (QString fileName, metadataDir.entryList(QStringList() << "*.json", QDir::Files))
			loadMetadata(metadataDir.absoluteFilePath(fileName));
	}

	std::sort(m_components.begin(), m_components.end(), componentCompare);
	m_componentsLoaded = true;

	foreach(SambaComponent* comp, m_components) {
		qCDebug(sambaLogQml, "Component '%s' (%s), prio %d.",
				comp->name().toLocal8Bit().constData(),
				comp->aliases().join(", ").toLocal8Bit().constData(),
				comp->priority());
	}

}

QList<SambaComponent*> SambaMetadata::listComponents(SambaComponentType type)
{
	loadAllMetadata();

	QList<SambaComponent*> list;
	foreach (SambaComponent* comp, m_components) {
		if (comp->type() == type)
			list << comp;
	}

	return list;
}

SambaComponent* SambaMetadata::findComponent(SambaComponentType type, const QString& name)
{
	loadAllMetadata();

	return findObject(m_components, type, name);
}
