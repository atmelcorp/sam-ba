#include "sambaconnectionpluginserial.h"
#include "sambaconnectionserial.h"

SambaConnectionPluginSerial::SambaConnectionPluginSerial(QObject *parent)
	: SambaPlugin(parent)
{

}

bool SambaConnectionPluginSerial::initPlugin(SambaCore* core)
{
	core->registerConnection(new SambaConnectionSerial(core, false));
	core->registerConnection(new SambaConnectionSerial(core, true));
	return true;
}
