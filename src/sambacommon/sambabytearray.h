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

#ifndef SAMBABYTEARRAY_H
#define SAMBABYTEARRAY_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaByteArray : public QObject
{
	Q_OBJECT
	Q_PROPERTY(unsigned length READ length NOTIFY lengthChanged)

public:
	explicit SambaByteArray();
	explicit SambaByteArray(int length);
	explicit SambaByteArray(const QByteArray& data);
	explicit SambaByteArray(const SambaByteArray& data);

	unsigned length() const {
		return m_data.length();
	}

	void setData(const QByteArray& data)
	{
		m_data = data;
		emit lengthChanged();
	}

	const QByteArray &constData() const
	{
		return m_data;
	}

	Q_INVOKABLE void pad(unsigned count, quint8 value);
	Q_INVOKABLE SambaByteArray *mid(unsigned index, unsigned len) const;
	Q_INVOKABLE void prepend(SambaByteArray* other);
	Q_INVOKABLE void append(SambaByteArray* other);
	Q_INVOKABLE QVariant compare(SambaByteArray* other);

	Q_INVOKABLE quint8 readu8(int offset) const;
	Q_INVOKABLE void writeu8(int offset, quint8 value);
	Q_INVOKABLE quint16 readu16(int offset) const;
	Q_INVOKABLE void writeu16(int offset, quint16 value);
	Q_INVOKABLE quint32 readu32(int offset) const;
	Q_INVOKABLE void writeu32(int offset, quint32 value);

	Q_INVOKABLE bool readUrl(const QString& fileUrl);
	Q_INVOKABLE bool readFile(const QString& fileName);
	Q_INVOKABLE bool writeFile(const QString& fileName) const;

signals:
	void lengthChanged();

private:
	QByteArray m_data;
};

#endif // SAMBABYTEARRAY_H
