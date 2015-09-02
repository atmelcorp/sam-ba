#include "sambacore.h"
#include "sambalogger.h"
#include "sambascript.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaplugin.h"
#include "utils.h"
#include <QFile>
#include <QThread>

Q_LOGGING_CATEGORY(sambaLogCore, "samba.core")
Q_LOGGING_CATEGORY(sambaLogApplet, "samba.applet")
Q_LOGGING_CATEGORY(sambaLogQml, "samba.qml")

SambaCore::SambaCore(QObject *parent) :	QObject(parent)
{
	// forward signals from engine
	QObject::connect(&m_scriptEngine, &QQmlEngine::quit, this, &SambaCore::engineQuit, Qt::QueuedConnection);
	QObject::connect(&m_scriptEngine, &QQmlEngine::warnings, this, &SambaCore::engineWarnings);

	// register singletons
	m_scriptEngine.rootContext()->setContextProperty("samba", this);
	m_scriptEngine.rootContext()->setContextProperty("logger", SambaLogger::getInstance());
	m_scriptEngine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");

	loadPlugins(QDir(QCoreApplication::applicationDirPath()));
	emit connectionsChanged();

	loadDevices(QDir(QCoreApplication::applicationDirPath() + "/devices"));
	emit devicesChanged();
}

void SambaCore::loadPlugins(const QDir &pluginsDir)
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

void SambaCore::loadDevices(const QDir &devicesDir)
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

void SambaCore::engineQuit()
{
	QCoreApplication::quit();
}

void SambaCore::engineWarnings(const QList<QQmlError> &warnings)
{
	qCWarning(sambaLogQml) << warnings;
}

SambaCore::~SambaCore()
{
}

QQmlEngine* SambaCore::scriptEngine()
{
	return &m_scriptEngine;
}

void SambaCore::evaluateScript(const QString &program)
{
	m_scriptEngine.evaluate(program);
}

bool SambaCore::evaluateScript(const QUrl &url)
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

void SambaCore::registerConnection(SambaConnection *conn)
{
	conn->refreshPorts();
	m_connections.append(conn);
	qCDebug(sambaLogCore, "Registered connection %s (%s)", conn->tag().toLatin1().constData(),
		   conn->name().toLatin1().constData());
}

QQmlListProperty<SambaConnection> SambaCore::getConnectionsListProperty()
{
	return QQmlListPropertyOnQList<
				SambaCore,
				SambaConnection,
				QList<SambaConnection*>,
				&SambaCore::m_connections,
				&SambaCore::connectionsChanged>::createList(this);
}

SambaConnection *SambaCore::connection(const QString &tag)
{
	SambaConnection *conn;
	foreach (conn, m_connections)
	{
		if (conn->tag() == tag)
			return conn;
	}
	return NULL;
}

QQmlListProperty<QObject> SambaCore::getDevicesListProperty()
{
	return QQmlListPropertyOnQList<
				SambaCore,
				QObject,
				QList<QObject*>,
				&SambaCore::m_devices,
				&SambaCore::devicesChanged>::createList(this);
}

QObject *SambaCore::device(const QString &tag)
{
	QObject *device;
	foreach (device, m_devices)
	{
		if (device->property("tag").toString() == tag)
			return device;
	}
	return NULL;
}

void SambaCore::sleep(int secs)
{
	QThread::sleep(secs);
}

void SambaCore::msleep(int msecs)
{
	QThread::msleep(msecs);
}

void SambaCore::usleep(int usecs)
{
	QThread::usleep(usecs);
}
