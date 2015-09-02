#ifndef SAMBA_CONNECTION_SERIAL_H
#define SAMBA_CONNECTION_SERIAL_H

#include "sambaconnection.h"

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnSerial)

class Q_DECL_EXPORT SambaConnectionSerial : public SambaConnection
{
public:
	SambaConnectionSerial(QObject *parent, bool at91);
	~SambaConnectionSerial();

	Q_INVOKABLE virtual void refreshPorts();

private:
	bool m_at91;
};

#endif // SAMBA_CONNECTION_SERIAL_H
