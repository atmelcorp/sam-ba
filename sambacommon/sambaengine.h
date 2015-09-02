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

	QQmlEngine *scriptEngine();
	void evaluateScript(const QString &program);
	bool evaluateScript(const QUrl &url);

private slots:
	void engineQuit();
	void engineWarnings(const QList<QQmlError> &warnings);

private:
	QQmlEngine m_scriptEngine;
};

#endif // SAMBA_ENGINE_H
