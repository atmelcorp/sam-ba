#ifndef SAMBA_DEVICE_H
#define SAMBA_DEVICE_H

#include "sambacore_global.h"
#include "sambaobject.h"
#include "sambaapplet.h"
#include <QObject>
#include <QtQml>

class SAMBACORESHARED_EXPORT SambaDevice : public SambaObject
{
    Q_OBJECT

	Q_PROPERTY(QQmlListProperty<SambaApplet> applets READ getAppletsListProperty NOTIFY appletsChanged)

public:
	explicit SambaDevice(QObject *parent = 0);
	~SambaDevice();

	QQmlListProperty<SambaApplet> getAppletsListProperty();

	// script methods

	Q_INVOKABLE SambaApplet *firstAppletOfKind(SambaApplet::AppletKind kind);

	Q_INVOKABLE QList<QVariant> appletsOfKind(SambaApplet::AppletKind kind);

	Q_INVOKABLE SambaApplet *applet(const QString& tag);

signals:
	void appletsChanged();

private:
	QList<SambaApplet*> m_applets;
};

#endif // SAMBA_DEVICE_H
