#ifndef SAMBA_ENGINE_H
#define SAMBA_ENGINE_H

#include "sambacommon.h"
#include <QObject>
#include <QUrl>
#include <QtQml>

class SAMBACOMMONSHARED_EXPORT SambaEngine : public QObject
{
	Q_OBJECT

public:
	explicit SambaEngine(QObject *parent = 0);
	~SambaEngine();

	QQmlEngine* qmlEngine();
	QObject* createComponentInstance(QQmlComponent* component, QQmlContext* context);
	QObject* createComponentInstance(const QString& script, QQmlContext* context);
	QObject* createComponentInstance(const QUrl &url, QQmlContext* context);

private slots:
	void engineQuit();
	void engineWarnings(const QList<QQmlError> &warnings);

private:
	QQmlEngine m_qmlEngine;
	bool m_hasWarnings;
};

#endif // SAMBA_ENGINE_H
