#ifndef SAMBA_CONNECTION_PLUGIN_JLINK_H
#define SAMBA_CONNECTION_PLUGIN_JLINK_H

#include "sambaplugin.h"
#include <QObject>

class Q_DECL_EXPORT SambaConnectionPluginJlink : public SambaPlugin
{
	Q_OBJECT

	Q_PLUGIN_METADATA(IID SambaPlugin_iid)

public:
	SambaConnectionPluginJlink(QObject *parent = 0);

	virtual bool initPlugin(SambaCore* core);
};

#endif // SAMBA_CONNECTION_PLUGIN_JLINK_H
