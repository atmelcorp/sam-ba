#include "sambaconnection.h"

SambaConnection::SambaConnection(QObject *parent) : SambaObject(parent)
{

}

SambaConnection::~SambaConnection()
{

}

QQmlListProperty<SambaConnectionPort> SambaConnection::getPortsListProperty()
{
	return QQmlListProperty<SambaConnectionPort>(this, m_ports);
}

SambaConnectionPort *SambaConnection::port(const QString &portName)
{
	SambaConnectionPort *port;
	foreach (port, m_ports) {
		if (port->name() == portName)
			return port;
	}
	return NULL;
}

void SambaConnection::refreshPorts()
{
	emit portsChanged();
}
