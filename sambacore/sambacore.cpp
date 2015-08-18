#include "sambacore.h"
#include "sambalogger.h"
#include "sambascript.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaplugin.h"
#include "utils.h"
#include <QDebug>
#include <QFile>
#include <QThread>

SambaCore::SambaCore(QObject *parent) :	QObject(parent)
{
	// forward signals from engine
	QObject::connect(&m_scriptEngine, &QQmlEngine::quit, this, &SambaCore::engineQuit, Qt::QueuedConnection);
	QObject::connect(&m_scriptEngine, &QQmlEngine::warnings, this, &SambaCore::engineWarnings);

	// register Samba types
	qmlRegisterType<SambaScript>("SAMBA", 1, 0, "Script");
	qmlRegisterType<SambaApplet>("SAMBA", 1, 0, "Applet");
	qmlRegisterType<SambaDevice>("SAMBA", 1, 0, "Device");
	qmlRegisterType<SambaConnection>("SAMBA", 1, 0, "Connection");
	qmlRegisterType<SambaConnectionPort>("SAMBA", 1, 0, "ConnectionPort");
	qRegisterMetaType<SambaApplet::AppletKind>("SambaApplet::AppletKind");

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
	qDebug("Loading plugins from %s", pluginsDir.path().toLatin1().constData());
	foreach (QString fileName, pluginsDir.entryList(QStringList("*sambaplugin_*"), QDir::Files))
	{
		qDebug("Loading plugin %s", fileName.toLatin1().constData());
		QPluginLoader loader(pluginsDir.absoluteFilePath(fileName));
		QObject *plugin = loader.instance();
		if (plugin)
		{
			SambaPlugin *sambaPlugin = qobject_cast<SambaPlugin*>(plugin);
			if (sambaPlugin)
			{
				if (sambaPlugin->initPlugin(this))
				{
					qDebug("Plugin %s loaded", fileName.toLatin1().constData());
				}
			}
		}
		else
		{
			qDebug("Error while loading plugin %s: %s", fileName.toLatin1().constData(), loader.errorString().toLatin1().constData());
		}
	}

	foreach (QString dirName, pluginsDir.entryList(QDir::Dirs))
	{
		if (dirName != "." && dirName != "..")
		{
			QDir subDir(pluginsDir);
			subDir.cd(dirName);
			loadPlugins(subDir);
		}
	}
}

void SambaCore::loadDevices(const QDir &devicesDir)
{
	qDebug("Loading devices from %s", devicesDir.path().toLatin1().constData());
	foreach (QString fileName, devicesDir.entryList(QStringList() << "*.qml", QDir::Files))
	{
		qDebug("Loading device file %s", fileName.toLatin1().constData());
		QQmlComponent component(&m_scriptEngine, QUrl::fromLocalFile(devicesDir.absoluteFilePath(fileName)));
		QObject* dev = component.create();
		if (!dev)
		{
			qDebug() << component.errors();
		}
		else
		{
			m_devices.append(dev);
			qDebug("Registered device %s (%s)", dev->property("tag").toString().toLatin1().constData(),
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
	qDebug() << warnings;
}

SambaCore::~SambaCore()
{
}

QQmlEngine* SambaCore::scriptEngine()
{
	return &m_scriptEngine;
}

QVariant SambaCore::evaluateScript(const QString &program)
{
	return m_scriptEngine.evaluate(program).toVariant();
}

QVariant SambaCore::evaluateScript(const QUrl &url)
{
	QQmlComponent component(&m_scriptEngine, url);
	if (component.status() != QQmlComponent::Ready)
		return QVariant(component.errorString());

	SambaScript* obj = qobject_cast<SambaScript*>(component.create());
	if (!obj)
		return QVariant("Script root component must be SambaScript");
	obj->startScript();
	delete obj;

	return QVariant();
}

void SambaCore::registerConnection(SambaConnection *conn)
{
	conn->refreshPorts();
	m_connections.append(conn);
	qDebug("Registered connection %s (%s)", conn->tag().toLatin1().constData(),
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
