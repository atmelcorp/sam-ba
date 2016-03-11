#include "sambacoreplugin.h"
#include "sambaabstractapplet.h"
#include "sambabytearray.h"
#include "sambaconnection.h"
#include "sambautils.h"

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));
	qmlRegisterType<SambaAbstractApplet>(uri, 3, 0, "AbstractApplet");
	qmlRegisterType<SambaByteArray>(uri, 3, 0, "ByteArray");
	qmlRegisterType<SambaConnection>(uri, 3, 0, "ConnectionBase");
	qmlRegisterType<SambaUtils>(uri, 3, 0, "UtilsBase");
}
