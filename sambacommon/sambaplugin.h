#ifndef SAMBA_PLUGIN_H
#define SAMBA_PLUGIN_H

#include "sambacommon.h"
#include "sambaengine.h"
#include <QObject>

#define SambaPlugin_iid "com.atmel.samba3.SambaPlugin"

class SAMBACOMMONSHARED_EXPORT SambaPlugin : public QObject
{
	Q_OBJECT

public:
	SambaPlugin(QObject *parent = 0) { Q_UNUSED(parent); }
	virtual ~SambaPlugin() {}

	virtual bool initPlugin(SambaEngine* engine) = 0;
};

#endif // SAMBA_CONNECTION_PLUGIN_H
