#ifndef SAMBA_PLUGIN_H
#define SAMBA_PLUGIN_H

#include "sambacore_global.h"
#include "sambacore.h"
#include <QObject>

#define SambaPlugin_iid "com.atmel.samba3.SambaPlugin"

class SAMBACORESHARED_EXPORT SambaPlugin : public QObject
{
	Q_OBJECT

public:
	SambaPlugin(QObject *parent = 0) { Q_UNUSED(parent); }
	virtual ~SambaPlugin() {}

	virtual bool initPlugin(SambaCore* core) = 0;
};

#endif // SAMBA_CONNECTION_PLUGIN_H
