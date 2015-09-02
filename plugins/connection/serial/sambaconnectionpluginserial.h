#ifndef SAMBA_CONNECTION_PLUGIN_SERIAL_H
#define SAMBA_CONNECTION_PLUGIN_SERIAL_H

#include <QObject>
#include "sambaplugin.h"

class Q_DECL_EXPORT SambaConnectionPluginSerial : public SambaPlugin
{
	Q_OBJECT

	Q_PLUGIN_METADATA(IID SambaPlugin_iid)

public:
	SambaConnectionPluginSerial(QObject *parent = 0);

	virtual bool initPlugin(SambaCore* core);
};

#endif // SAMBA_CONNECTION_PLUGIN_SERIAL_H
