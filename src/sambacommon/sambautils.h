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

#ifndef SAMBA_UTILS_H
#define SAMBA_UTILS_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaUtils : public QObject
{
	Q_OBJECT

public:
	explicit SambaUtils();

	Q_INVOKABLE void sleep(int secs) const;
	Q_INVOKABLE void msleep(int msecs) const;
	Q_INVOKABLE void usleep(int usecs) const;

	Q_INVOKABLE QVariant compareBuffers(const QByteArray& buffer1, const QByteArray& buffer2) const;
	Q_INVOKABLE unsigned getBufferTrimCount(const QByteArray& buffer, unsigned offset, unsigned pages, unsigned pageSize, char paddingByte) const;
};

#endif // SAMBA_UTILS_H
