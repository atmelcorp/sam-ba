#include "sambascript.h"

SambaScript::SambaScript(QObject *parent) : QObject(parent)
{

}

SambaScript::~SambaScript()
{

}

void SambaScript::startScript()
{
	emit scriptStarted();
}
