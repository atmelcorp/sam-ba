#ifndef SAMBA_CORE_H
#define SAMBA_CORE_H

#include "sambacore_global.h"
#include "sambaconnection.h"
#include "sambadevice.h"
#include <QObject>
#include <QLoggingCategory>
#include <QScopedPointer>
#include <QUrl>
#include <QtQml>

Q_DECLARE_LOGGING_CATEGORY(sambaLogCore)
Q_DECLARE_LOGGING_CATEGORY(sambaLogApplet)
Q_DECLARE_LOGGING_CATEGORY(sambaLogQml)

class SAMBACORESHARED_EXPORT SambaCore : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QQmlListProperty<SambaConnection> connections READ getConnectionsListProperty NOTIFY connectionsChanged)
	Q_PROPERTY(QQmlListProperty<QObject> devices READ getDevicesListProperty NOTIFY devicesChanged)

public:
	explicit SambaCore(QObject *parent = 0);
	~SambaCore();

	QQmlEngine *scriptEngine();
	void evaluateScript(const QString &program);
	bool evaluateScript(const QUrl &url);

	void registerConnection(SambaConnection *conn);

	// properties

	QQmlListProperty<SambaConnection> getConnectionsListProperty();
	QQmlListProperty<QObject> getDevicesListProperty();

	// script methods

	Q_INVOKABLE SambaConnection *connection(const QString &tag);
	Q_INVOKABLE QObject *device(const QString &tag);

	// script utils

	Q_INVOKABLE void sleep(int secs);
	Q_INVOKABLE void msleep(int msecs);
	Q_INVOKABLE void usleep(int usecs);

signals:
	void connectionsChanged();
	void devicesChanged();

private:
	void loadPlugins(const QDir &pluginsDir);
	void loadDevices(const QDir &devicesDir);

private slots:
	void engineQuit();
	void engineWarnings(const QList<QQmlError> &warnings);

private:
	QQmlEngine m_scriptEngine;
	QList<SambaConnection*> m_connections;
	QList<QObject*> m_devices;
};

#endif // SAMBA_CORE_H
