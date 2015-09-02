#include "sambaengine.h"
#include "sambalogger.h"
#include "sambascript.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaplugin.h"
#include "utils.h"
#include <QFile>
#include <QThread>

SambaEngine::SambaEngine(QObject *parent) :	QObject(parent)
{
	// forward signals from engine
	QObject::connect(&m_scriptEngine, &QQmlEngine::quit, this, &SambaEngine::engineQuit, Qt::QueuedConnection);
	QObject::connect(&m_scriptEngine, &QQmlEngine::warnings, this, &SambaEngine::engineWarnings);

	// register singletons
	m_scriptEngine.rootContext()->setContextProperty("samba", this);
	m_scriptEngine.rootContext()->setContextProperty("logger", SambaLogger::getInstance());
	m_scriptEngine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");

	loadPlugins(QDir(QCoreApplication::applicationDirPath()));
	emit connectionsChanged();

	loadDevices(QDir(QCoreApplication::applicationDirPath() + "/devices"));
	emit devicesChanged();
}

void SambaEngine::loadPlugins(const QDir &pluginsDir)
{
	qCDebug(sambaLogCore, "Loading plugins from %s", pluginsDir.path().toLatin1().constData());
	foreach (QString fileName, pluginsDir.entryList(QStringList("*sambaplugin_*"), QDir::Files))
	{
		qCDebug(sambaLogCore, "Loading plugin %s", fileName.toLatin1().constData());
		QPluginLoader loader(pluginsDir.absoluteFilePath(fileName));
		QObject *plugin = loader.instance();
		if (plugin)
		{
			SambaPlugin *sambaPlugin = qobject_cast<SambaPlugin*>(plugin);
			if (sambaPlugin)
			{
				if (sambaPlugin->initPlugin(this))
				{
					qCDebug(sambaLogCore, "Plugin %s loaded", fileName.toLatin1().constData());
				}
			}
		}
		else
		{
			qCWarning(sambaLogCore, "Error while loading plugin %s: %s", fileName.toLatin1().constData(), loader.errorString().toLatin1().constData());
		}
	}
}

void SambaEngine::loadDevices(const QDir &devicesDir)
{
	qCDebug(sambaLogCore, "Loading devices from %s", devicesDir.path().toLatin1().constData());
	foreach (QString fileName, devicesDir.entryList(QStringList("*.qml"), QDir::Files))
	{
		qCDebug(sambaLogCore, "Loading device file %s", fileName.toLatin1().constData());
		QQmlComponent component(&m_scriptEngine, QUrl::fromLocalFile(devicesDir.absoluteFilePath(fileName)));
		QObject* dev = component.create();
		if (!dev)
		{
			qCCritical(sambaLogCore) << component.errors();
		}
		else
		{
			m_devices.append(dev);
			qCDebug(sambaLogCore, "Registered device %s (%s)", dev->property("tag").toString().toLatin1().constData(),
				   dev->property("name").toString().toLatin1().constData());
		}
	}
}

void SambaEngine::engineQuit()
{
	QCoreApplication::quit();
}

void SambaEngine::engineWarnings(const QList<QQmlError> &warnings)
{
	qCWarning(sambaLogQml) << warnings;
}

SambaEngine::~SambaEngine()
{
}

QQmlEngine* SambaEngine::scriptEngine()
{
	return &m_scriptEngine;
}

void SambaEngine::evaluateScript(const QString &program)
{
	m_scriptEngine.evaluate(program);
}

bool SambaEngine::evaluateScript(const QUrl &url)
{
	QQmlComponent component(&m_scriptEngine, url);
	if (component.status() != QQmlComponent::Ready)
	{
		qCCritical(sambaLogCore) << component.errorString();
		return false;
	}

	SambaScript* obj = qobject_cast<SambaScript*>(component.create());
	if (!obj)
	{
		qCCritical(sambaLogCore, "Script root component must be SambaScript");
		return false;
	}
	obj->startScript();
	delete obj;

	return true;
}

void SambaEngine::registerConnection(SambaConnection *conn)
{
	conn->refreshPorts();
	m_connections.append(conn);
	qCDebug(sambaLogCore, "Registered connection %s (%s)", conn->tag().toLatin1().constData(),
		   conn->name().toLatin1().constData());
}

QQmlListProperty<SambaConnection> SambaEngine::getConnectionsListProperty()
{
	return QQmlListPropertyOnQList<
				SambaEngine,
				SambaConnection,
				QList<SambaConnection*>,
				&SambaEngine::m_connections,
				&SambaEngine::connectionsChanged>::createList(this);
}

SambaConnection *SambaEngine::connection(const QString &tag)
{
	SambaConnection *conn;
	foreach (conn, m_connections)
	{
		if (conn->tag() == tag)
			return conn;
	}
	return NULL;
}

QQmlListProperty<QObject> SambaEngine::getDevicesListProperty()
{
	return QQmlListPropertyOnQList<
				SambaEngine,
				QObject,
				QList<QObject*>,
				&SambaEngine::m_devices,
				&SambaEngine::devicesChanged>::createList(this);
}

QObject *SambaEngine::device(const QString &tag)
{
	QObject *device;
	foreach (device, m_devices)
	{
		if (device->property("tag").toString() == tag)
			return device;
	}
	return NULL;
}

void SambaEngine::sleep(int secs)
{
	QThread::sleep(secs);
}

void SambaEngine::msleep(int msecs)
{
	QThread::msleep(msecs);
}

void SambaEngine::usleep(int usecs)
{
	QThread::usleep(usecs);
}
