#include "sambacoreplugin.h"
#include "sambaabstractapplet.h"
#include "sambabytearray.h"
#include "sambaconnection.h"
#include "sambautils.h"

static QObject *sambautils_singletontype_provider(QQmlEngine *qmlEngine, QJSEngine *jsEngine)
{
	Q_UNUSED(qmlEngine)
	Q_UNUSED(jsEngine)
	return new SambaUtils();
}

void SambaCorePlugin::registerTypes(const char *uri)
{
	Q_ASSERT(uri == QLatin1String("SAMBA"));
	qmlRegisterType<SambaAbstractApplet>(uri, 3, 0, "AbstractApplet");
	qmlRegisterType<SambaByteArray>(uri, 3, 0, "ByteArray");
	qmlRegisterType<SambaConnection>(uri, 3, 0, "ConnectionBase");
	qmlRegisterSingletonType<SambaUtils>(uri, 3, 0, "Utils", sambautils_singletontype_provider);
}
