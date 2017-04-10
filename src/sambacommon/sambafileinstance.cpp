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

#include "sambacommon.h"
#include "sambafileinstance.h"
#include <QUrl>
#include <QFile>
#include <QThread>
#include <QLoggingCategory>

SambaFileInstance::SambaFileInstance(QObject* parent)
	: QObject(parent)
{
}

SambaFileInstance::~SambaFileInstance()
{
	m_file.close();
}

bool SambaFileInstance::open(const QString& pathOrUrl, bool write)
{
	QUrl url(pathOrUrl, QUrl::StrictMode);

	if (url.isValid() && url.isLocalFile()) {
		m_file.setFileName(url.toLocalFile());
	} else {
		m_file.setFileName(pathOrUrl);
	}

	return m_file.open(write ? QIODevice::WriteOnly : QIODevice::ReadOnly);
}

bool SambaFileInstance::atEnd() const
{
	return m_file.atEnd();
}

qint64 SambaFileInstance::size() const
{
	return m_file.size();
}

qint64 SambaFileInstance::pos() const
{
	return m_file.pos();
}

bool SambaFileInstance::seek(qint64 offset)
{
	return m_file.seek(offset);
}

QByteArray SambaFileInstance::read(qint64 maxSize)
{
	return m_file.read(maxSize);
}

QByteArray SambaFileInstance::readAll()
{
	return m_file.readAll();
}

qint64 SambaFileInstance::write(const QByteArray &byteArray)
{
	return m_file.write(byteArray);
}

void SambaFileInstance::close()
{
	m_file.close();
}
