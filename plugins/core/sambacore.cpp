#include "sambacore.h"
#include "sambascript.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaconnection.h"
#include "sambaconnectionport.h"

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));

	qmlRegisterType<SambaScript>(uri, 1, 0, "Script");
	qmlRegisterType<SambaApplet>(uri, 1, 0, "Applet");
	qmlRegisterType<SambaDevice>(uri, 1, 0, "Device");
	qmlRegisterType<SambaConnection>(uri, 1, 0, "Connection");
	qmlRegisterType<SambaConnectionPort>(uri, 1, 0, "ConnectionPort");
	qRegisterMetaType<SambaApplet::AppletKind>("SambaApplet::AppletKind");
}
