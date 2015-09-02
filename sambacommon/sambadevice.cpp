#include "sambadevice.h"
#include "utils.h"

SambaDevice::SambaDevice(QObject *parent) : SambaObject(parent)
{

}

SambaDevice::~SambaDevice()
{

}

QQmlListProperty<SambaApplet> SambaDevice::getAppletsListProperty()
{
	return QQmlListPropertyOnQList<
				SambaDevice,
				SambaApplet,
				QList<SambaApplet*>,
				&SambaDevice::m_applets,
				&SambaDevice::appletsChanged>::createList(this);
}

SambaApplet *SambaDevice::firstAppletOfKind(SambaApplet::AppletKind kind)
{
	SambaApplet* applet;
	foreach (applet, m_applets) {
		if (applet->kind() == kind)
			return applet;
	}
	return NULL;
}

QList<QVariant> SambaDevice::appletsOfKind(SambaApplet::AppletKind kind)
{
	QVariantList applets;
	SambaApplet* applet;
	foreach (applet, m_applets) {
		if (applet->kind() == kind)
			applets.append(QVariant::fromValue((QObject*)(applet)));
	}
	return applets;
}

SambaApplet *SambaDevice::applet(const QString& tag)
{
	SambaApplet* applet;
	foreach (applet, m_applets) {
		if (applet->tag() == tag)
			return applet;
	}
	return NULL;
}
