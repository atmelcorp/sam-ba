#ifndef SAMBA_CONNECTION_JLINK_H
#define SAMBA_CONNECTION_JLINK_H

#include "sambaconnection.h"

class Q_DECL_EXPORT SambaConnectionJlink : public SambaConnection
{
public:
	SambaConnectionJlink(QObject *parent = 0);
	~SambaConnectionJlink();

	Q_INVOKABLE virtual void refreshPorts();
};

#endif // SAMBA_CONNECTION_JLINK_H
