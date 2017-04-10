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

#ifndef SAMBAFILEINSTANCE_H
#define SAMBAFILEINSTANCE_H

#include "sambacommon.h"
#include <QFile>
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaFileInstance : public QObject
{
	Q_OBJECT

public:
	explicit SambaFileInstance(QObject* parent = 0);
	~SambaFileInstance();

	bool open(const QString& pathOrUrl, bool write);

	Q_INVOKABLE bool atEnd() const;
	Q_INVOKABLE qint64 size() const;
	Q_INVOKABLE qint64 pos() const;
	Q_INVOKABLE bool seek(qint64 offset);
	Q_INVOKABLE QByteArray read(qint64 maxSize);
	Q_INVOKABLE QByteArray readAll();
	Q_INVOKABLE qint64 write(const QByteArray &byteArray);
	Q_INVOKABLE void close();

private:
	QFile m_file;
};

#endif // SAMBAFILEINSTANCE_H
