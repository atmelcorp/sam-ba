#include "sambascript.h"
#include <QThread>

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

void SambaScript::sleep(int secs)
{
	QThread::sleep(secs);
}

void SambaScript::msleep(int msecs)
{
	QThread::msleep(msecs);
}

void SambaScript::usleep(int usecs)
{
	QThread::usleep(usecs);
}
