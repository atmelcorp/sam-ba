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

#include <QByteArray>
#include <QFile>
#include <QObject>

class SambaFileInstance : public QObject
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

	Q_INVOKABLE void setHeader(const QByteArray& header);
	Q_INVOKABLE void enable6thVectorPatching(bool enable);
	Q_INVOKABLE void setPaddingByte(quint8 value);
	Q_INVOKABLE void setPaddingBefore(int count);
	Q_INVOKABLE void setPaddingAfter(int count);

private:
	QFile m_file;
	qint64 m_offset;
	QByteArray m_header;
	bool m_enable6thVectorPatching;
	quint8 m_paddingValue;
	int m_paddingBefore;
	int m_paddingAfter;
};

#endif // SAMBAFILEINSTANCE_H
