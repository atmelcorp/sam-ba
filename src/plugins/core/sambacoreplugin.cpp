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

#include "sambacoreplugin.h"
#include "sambaapplet.h"
#include "sambaappletcommand.h"
#include "sambabytearray.h"
#include "sambaconnection.h"
#include "sambadevice.h"
#include "sambautils.h"

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));
	qmlRegisterType<SambaApplet>(uri, 3, 0, "AppletBase");
	qmlRegisterType<SambaAppletCommand>(uri, 3, 0, "AppletCommandBase");
	qmlRegisterType<SambaByteArray>(uri, 3, 0, "ByteArray");
	qmlRegisterType<SambaConnection>(uri, 3, 0, "ConnectionBase");
	qmlRegisterType<SambaDevice>(uri, 3, 0, "DeviceBase");
	qmlRegisterType<SambaUtils>(uri, 3, 0, "UtilsBase");
}
