#include "sambaengine.h"
#include <QFile>

SambaEngine::SambaEngine(QObject *parent) : QObject(parent)
{
	m_scriptEngine.setOutputWarningsToStandardError(false);

	// forward signals from engine
	QObject::connect(&m_scriptEngine, &QQmlEngine::quit,
					 this, &SambaEngine::engineQuit, Qt::QueuedConnection);
	QObject::connect(&m_scriptEngine, &QQmlEngine::warnings,
					 this, &SambaEngine::engineWarnings);

	// add import path
	m_scriptEngine.addImportPath(QCoreApplication::applicationDirPath() + "/qml");
}

void SambaEngine::engineQuit()
{
	QCoreApplication::quit();
}

void SambaEngine::engineWarnings(const QList<QQmlError> &warnings)
{
	foreach(QQmlError warning, warnings)
	{
		QString url;
		if (warning.url().isLocalFile())
			url = warning.url().toLocalFile();
		else
			url = warning.url().toString();
		qCWarning(sambaLogQml, "%s:%d: %s", url.toLocal8Bit().constData(),
				  warning.line(), warning.description().toLocal8Bit().constData());
	}
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

	QObject* obj = component.create();
	if (!obj)
	{
		qCCritical(sambaLogCore, "Cannot create script component");
		return false;
	}
	delete obj;

	return true;
}
