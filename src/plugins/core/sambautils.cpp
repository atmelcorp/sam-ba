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

#include "sambacore.h"
#include "sambautils.h"
#include <QThread>

SambaUtils::SambaUtils()
	: QObject(0)
{

}

void SambaUtils::sleep(int secs) const
{
	QThread::sleep(secs);
}

void SambaUtils::msleep(int msecs) const
{
	QThread::msleep(msecs);
}

void SambaUtils::usleep(int usecs) const
{
	QThread::usleep(usecs);
}

QVariant SambaUtils::compareBuffers(const QByteArray& buffer1, const QByteArray& buffer2) const
{
	unsigned i;

	for (i = 0; i < (unsigned)qMin(buffer1.length(), buffer2.length()); i++) {
		if (buffer1[i] != buffer2[i])
			return QVariant(i);
	}

	if (buffer1.length() != buffer2.length())
		return QVariant(i);

	return QVariant();
}

unsigned SambaUtils::getBufferTrimCount(const QByteArray& buffer, unsigned offset, unsigned pages, unsigned pageSize, char paddingByte) const
{
	unsigned page;

	if (offset + pages * pageSize > (unsigned)buffer.length())
		return 0;

	for (page = pages; page > 0; page--) {
		bool empty = true;
		for (unsigned i = 0; i < pageSize; i++) {
			if (buffer[offset + (page - 1) * pageSize + i] != paddingByte) {
				empty = false;
				break;
			}
		}
		if (!empty)
			break;
	}

	return pages - page;
}
