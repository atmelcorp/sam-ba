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

#ifndef SAMBA_COMMON_GLOBAL_H
#define SAMBA_COMMON_GLOBAL_H

#include <QtCore/qglobal.h>
#include <QLoggingCategory>

#if defined(SAMBACOMMON_LIBRARY)
#  define SAMBACOMMONSHARED_EXPORT Q_DECL_EXPORT
#else
#  define SAMBACOMMONSHARED_EXPORT Q_DECL_IMPORT
#endif

Q_DECLARE_LOGGING_CATEGORY(sambaLogCore)
Q_DECLARE_LOGGING_CATEGORY(sambaLogQml)

#endif // SAMBA_COMMON_GLOBAL_H
