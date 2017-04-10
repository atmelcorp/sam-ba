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
#include "sambafile.h"
#include "sambautils.h"

static QObject* file_instance_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine)
	Q_UNUSED(scriptEngine)
	return new SambaFile();
}

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));
	qmlRegisterType<SambaApplet>(uri, 3, 0, "AppletBase");
	qmlRegisterType<SambaAppletCommand>(uri, 3, 0, "AppletCommandBase");
	qmlRegisterType<SambaByteArray>(uri, 3, 0, "ByteArray");
	qmlRegisterType<SambaConnection>(uri, 3, 0, "ConnectionBase");
	qmlRegisterType<SambaDevice>(uri, 3, 0, "DeviceBase");
	qmlRegisterSingletonType<SambaFile>(uri, 3, 0, "File", file_instance_provider);
	qmlRegisterUncreatableType<SambaFileInstance>(uri, 3, 0, "FileInstance", "Please use SAMBA.File to create instances of this type");
	qmlRegisterType<SambaUtils>(uri, 3, 0, "UtilsBase");
}
