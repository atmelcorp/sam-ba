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

#ifndef SAMBA_METADATA_H
#define SAMBA_METADATA_H

#include "sambacommon.h"
#include "sambacomponent.h"
#include <QObject>
#include <QtQml>

class SambaEngine;

class SAMBACOMMONSHARED_EXPORT SambaMetadata
{
public:
	SambaMetadata(SambaEngine* engine);
	~SambaMetadata();

	QList<SambaComponent*> listComponents(SambaComponentType type);
	SambaComponent* findComponent(SambaComponentType type, const QString& name);

private:
	void loadAllMetadata();
	void loadMetadata(QString fileName);
private:
	SambaEngine* m_engine;
	bool m_componentsLoaded;
	QList<SambaComponent*> m_components;
};

#endif // SAMBA_METADATA_H
