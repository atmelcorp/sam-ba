#include "sambacoreplugin.h"
#include "sambautils.h"
#include "sambabytearray.h"

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
}
