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

#ifndef SAMBAFILE_H
#define SAMBAFILE_H

#include "sambafileinstance.h"
#include <QObject>

class SambaFile : public QObject
{
	Q_OBJECT

public:
	explicit SambaFile(QObject* parent = 0);

	Q_INVOKABLE SambaFileInstance* open(const QString& pathOrUrl, bool write);
	Q_INVOKABLE qint64 size(const QString& pathOrUrl) const;
};

#endif // SAMBAFILE_H
