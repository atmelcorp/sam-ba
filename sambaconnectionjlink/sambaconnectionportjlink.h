#ifndef SAMBA_CONNECTION_PORT_JLINK_H
#define SAMBA_CONNECTION_PORT_JLINK_H

#include "sambaconnectionport.h"
#include <JLinkARMDLL.h>

class Q_DECL_EXPORT SambaConnectionPortJlink : public SambaConnectionPort
{
public:
	SambaConnectionPortJlink(QObject *parent, U32 serial);
	~SambaConnectionPortJlink();

	// General
	bool connect();
	void disconnect();

	// Memory read
	quint8 readu8(quint32 address);
	quint16 readu16(quint32 address);
	quint32 readu32(quint32 address);
	QByteArray read(quint32 address, int length);

	// Memory write
	bool writeu8(quint32 address, quint8 data);
	bool writeu16(quint32 address, quint16 data);
	bool writeu32(quint32 address, quint32 data);
	bool write(quint32 address, const QByteArray &data);

	// Execute
	bool go(quint32 address);

protected:
	virtual quint32 appletCommType();

private:
	U32 m_serial;
	int m_devFamily, m_device;
};

#endif // SAMBA_CONNECTION_PORT_JLINK_H
