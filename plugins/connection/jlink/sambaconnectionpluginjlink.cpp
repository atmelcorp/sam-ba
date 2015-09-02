#include "sambaconnectionpluginjlink.h"
#include "sambaconnectionjlink.h"

SambaConnectionPluginJlink::SambaConnectionPluginJlink(QObject *parent) :
	SambaPlugin(parent)
{
}

bool SambaConnectionPluginJlink::initPlugin(SambaEngine* engine)
{
	engine->registerConnection(new SambaConnectionJlink(engine));
	return true;
}
