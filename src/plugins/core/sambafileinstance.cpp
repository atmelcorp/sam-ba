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

#include "sambacore.h"
#include "sambafileinstance.h"
#include <QUrl>
#include <QFile>
#include <QThread>
#include <QLoggingCategory>

SambaFileInstance::SambaFileInstance(QObject* parent)
	: QObject(parent),
	  m_offset(0),
	  m_enable6thVectorPatching(false),
	  m_paddingValue(0xff),
	  m_paddingBefore(0),
	  m_paddingAfter(0)
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
	return m_offset < size();
}

qint64 SambaFileInstance::size() const
{
	return m_paddingBefore + m_header.length() + m_file.size() + m_paddingAfter;
}

qint64 SambaFileInstance::pos() const
{
	return m_offset;
}

bool SambaFileInstance::seek(qint64 offset)
{
	if (offset >= size())
		return false;
	m_offset = offset;
	return true;
}

QByteArray SambaFileInstance::read(qint64 maxSize)
{
	QByteArray data;
	qint64 offset = m_offset;

	/* add 'before' padding */
	qint64 bpEnd = m_paddingBefore;
	qint64 bpLen = std::max(0ll, std::min(bpEnd - offset, maxSize));
	if (bpLen > 0) {
		data.append(bpLen, m_paddingValue);
		maxSize -= bpLen;
		offset += bpLen;
	}

	/* add data from header */
	qint64 headerStart = bpEnd;
	qint64 headerEnd = headerStart + m_header.length();
	qint64 headerLen = std::max(0ll, std::min(headerEnd - offset, maxSize));
	if (headerLen > 0) {
		data.append(m_header.mid(offset - headerStart, headerLen));
		maxSize -= headerLen;
		offset += headerLen;
	}

	/* add data from file */
	qint64 fileStart = headerEnd;
	qint64 fileEnd = fileStart + m_file.size();
	qint64 fileLen = std::max(0ll, std::min(fileEnd - offset, maxSize));
	if (fileLen > 0) {
		m_file.seek(offset - fileStart);
		data.append(m_file.read(fileLen));

		/* patch 6th vector if requested and inside the data range */
		if (m_enable6thVectorPatching) {
			qint64 fileOffset = offset - fileStart;
			if ((fileOffset <= 0x17) &&
			    (0x14 <= (fileOffset + fileLen))) {
				/* patch file size into 6th vector */
				quint32 fileSize = m_file.size();
				for (int i = 0; i < 4; i++) {
					int idx = (0x14 + i) - fileOffset;
					if (idx >= 0 && idx < fileLen)
						data[(int)(offset - m_offset + idx)] = (fileSize >> (8 * i)) & 0xff;
				}
			}
		}

		maxSize -= fileLen;
		offset += fileLen;
	}

	/* add 'after' padding */
	qint64 apStart = fileEnd;
	qint64 apEnd = apStart + m_paddingAfter;
	qint64 apLen = std::max(0ll, std::min(apEnd - offset, maxSize));
	if (apLen > 0) {
		data.append(apLen, m_paddingValue);
		maxSize -= apLen;
		offset += apLen;
	}

	m_offset = offset;
	return data;
}

QByteArray SambaFileInstance::readAll()
{
	return read(std::numeric_limits<qint64>::max());
}

qint64 SambaFileInstance::write(const QByteArray &byteArray)
{
	/* no need to handle header/patching/padding here, not applicable for write */
	m_file.seek(m_offset);
	qint64 count = m_file.write(byteArray);
	m_offset += count;
	return count;
}

void SambaFileInstance::close()
{
	m_file.close();
}

void SambaFileInstance::setHeader(const QByteArray& header)
{
	/* do nothing if the file is opened in write-only mode */
	if (m_file.openMode() == QIODevice::WriteOnly)
		return;

	m_header = header;
}

void SambaFileInstance::enable6thVectorPatching(bool enable)
{
	/* do nothing if the file is opened in write-only mode */
	if (m_file.openMode() == QIODevice::WriteOnly)
		return;

	m_enable6thVectorPatching = enable;
}

void SambaFileInstance::setPaddingByte(quint8 value)
{
	/* do nothing if the file is opened in write-only mode */
	if (m_file.openMode() == QIODevice::WriteOnly)
		return;

	m_paddingValue = value;
}

void SambaFileInstance::setPaddingBefore(int count)
{
	/* do nothing if the file is opened in write-only mode */
	if (m_file.openMode() == QIODevice::WriteOnly)
		return;

	m_paddingBefore = count;
}

void SambaFileInstance::setPaddingAfter(int count)
{
	/* do nothing if the file is opened in write-only mode */
	if (m_file.openMode() == QIODevice::WriteOnly)
		return;

	m_paddingAfter = count;
}
