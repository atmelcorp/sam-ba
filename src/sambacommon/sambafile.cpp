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

#include "sambafile.h"

SambaFile::SambaFile(QObject* parent)
	: QObject(parent)
{
}

SambaFileInstance* SambaFile::open(const QString& pathOrUrl, bool write)
{
	SambaFileInstance* file = new SambaFileInstance(this);

	if (!file->open(pathOrUrl, write)) {
		qCDebug(sambaLogCore, "Error: Could not open file '%s' for %s",
		        pathOrUrl.toLocal8Bit().constData(),
		        write ? "writing" : "reading");

		delete file;
		return nullptr;
	}

	return file;
}
