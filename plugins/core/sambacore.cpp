#include "sambacore.h"
#include "sambautils.h"
#include "sambabytearray.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaconnection.h"
#include "sambaconnectionport.h"

static QObject *sambautils_singletontype_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
	Q_UNUSED(engine)
	Q_UNUSED(scriptEngine)
	return new SambaUtils();
}

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));

	qmlRegisterSingletonType<SambaUtils>("SAMBA", 1, 0, "Utils", sambautils_singletontype_provider);
	qmlRegisterType<SambaByteArray>("SAMBA", 1, 0, "ByteArray");
	qmlRegisterType<SambaApplet>(uri, 1, 0, "Applet");
	qmlRegisterType<SambaDevice>(uri, 1, 0, "Device");
	qmlRegisterType<SambaConnection>(uri, 1, 0, "Connection");
	qmlRegisterType<SambaConnectionPort>(uri, 1, 0, "ConnectionPort");
	qRegisterMetaType<SambaApplet::AppletKind>("SambaApplet::AppletKind");
}
