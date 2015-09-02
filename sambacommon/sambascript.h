#ifndef SAMBA_SCRIPT_H
#define SAMBA_SCRIPT_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaScript : public QObject
{
	Q_OBJECT

public:
	explicit SambaScript(QObject *parent = 0);
	~SambaScript();

	// called by core, will emit scriptStarted signal
	void startScript();

	// utils
	Q_INVOKABLE void sleep(int secs);
	Q_INVOKABLE void msleep(int msecs);
	Q_INVOKABLE void usleep(int usecs);

signals:
	void scriptStarted();
};

#endif // SAMBA_SCRIPT_H
