#ifndef SAMBA_CONNECTION_H
#define SAMBA_CONNECTION_H

#include "sambacore_global.h"
#include "sambaobject.h"
#include "sambaconnectionport.h"
#include <QObject>
#include <QStringList>
#include <QtQml>

class SAMBACORESHARED_EXPORT SambaConnection : public SambaObject
{
	Q_OBJECT

	Q_PROPERTY(QQmlListProperty<SambaConnectionPort> ports READ getPortsListProperty NOTIFY portsChanged)

public:
	explicit SambaConnection(QObject *parent = 0);
	~SambaConnection();

	// properties
	QQmlListProperty<SambaConnectionPort> getPortsListProperty();

	// script methods

	Q_INVOKABLE SambaConnectionPort *port(const QString &portName);
	Q_INVOKABLE virtual void refreshPorts();

signals:
	void portsChanged();

protected:
	QList<SambaConnectionPort*> m_ports;
};

#endif // SAMBA_CONNECTION_H
