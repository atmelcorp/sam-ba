#include "sambaconnectionpluginserial.h"
#include "sambaconnectionserial.h"

SambaConnectionPluginSerial::SambaConnectionPluginSerial(QObject *parent)
	: SambaPlugin(parent)
{

}

bool SambaConnectionPluginSerial::initPlugin(SambaEngine* engine)
{
	engine->registerConnection(new SambaConnectionSerial(engine, false));
	engine->registerConnection(new SambaConnectionSerial(engine, true));
	return true;
}
