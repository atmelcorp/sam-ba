#include "sambaconnectionpluginjlink.h"
#include "sambaconnectionjlink.h"

SambaConnectionPluginJlink::SambaConnectionPluginJlink(QObject *parent) :
	SambaPlugin(parent)
{
}

bool SambaConnectionPluginJlink::initPlugin(SambaCore* core)
{
	core->registerConnection(new SambaConnectionJlink(core));
	return true;
}
