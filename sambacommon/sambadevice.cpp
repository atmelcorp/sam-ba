#include "sambadevice.h"

SambaDevice::SambaDevice(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name("")
{
}

QString SambaDevice::name() const
{
	return m_name;
}

void SambaDevice::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QQmlListProperty<SambaApplet> SambaDevice::applets()
{
	return QQmlListProperty<SambaApplet>(this, m_applets);
}

int SambaDevice::appletCount() const
{
	return m_applets.length();
}

SambaApplet *SambaDevice::applet(int index) const
{
	return m_applets.at(index);
}

SambaApplet* SambaDevice::applet(const QString& name) const
{
	foreach(SambaApplet* applet, m_applets) {
		if (applet->name() == name)
			return applet;
	}
	return 0;
}
