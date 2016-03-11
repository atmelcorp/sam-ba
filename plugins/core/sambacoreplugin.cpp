#include "sambacoreplugin.h"
#include "sambaapplet.h"
#include "sambabytearray.h"
#include "sambaconnection.h"
#include "sambadevice.h"
#include "sambautils.h"

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));
	qmlRegisterType<SambaApplet>(uri, 3, 0, "AppletBase");
	qmlRegisterType<SambaByteArray>(uri, 3, 0, "ByteArray");
	qmlRegisterType<SambaConnection>(uri, 3, 0, "ConnectionBase");
	qmlRegisterType<SambaDevice>(uri, 3, 0, "DeviceBase");
	qmlRegisterType<SambaUtils>(uri, 3, 0, "UtilsBase");
}
