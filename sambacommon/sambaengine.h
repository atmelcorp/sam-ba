#ifndef SAMBA_ENGINE_H
#define SAMBA_ENGINE_H

#include "sambacommon.h"
#include "sambaconnection.h"
#include "sambadevice.h"
#include <QObject>
#include <QUrl>
#include <QtQml>

class SAMBACOMMONSHARED_EXPORT SambaEngine : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QQmlListProperty<SambaConnection> connections READ getConnectionsListProperty NOTIFY connectionsChanged)
	Q_PROPERTY(QQmlListProperty<QObject> devices READ getDevicesListProperty NOTIFY devicesChanged)

public:
	explicit SambaEngine(QObject *parent = 0);
	~SambaEngine();

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

#endif // SAMBA_ENGINE_H
