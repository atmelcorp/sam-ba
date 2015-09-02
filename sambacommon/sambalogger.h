#ifndef SAMBALOGGER_H
#define SAMBALOGGER_H

#include "sambacommon.h"
#include <QObject>

class SambaLoggerEntry;

class SAMBACOMMONSHARED_EXPORT SambaLogger : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString text READ text NOTIFY textChanged)

private:
	SambaLogger();
	~SambaLogger();

public:
	static SambaLogger* getInstance();
	QString text() const;

	// script methods

	Q_INVOKABLE void append(const QString& message);
	Q_INVOKABLE void append(const QString& subsystem, const QString& message);

signals:
	void textChanged();

private:
	QList<SambaLoggerEntry*> m_entries;
	static SambaLogger* _instance;
};

#endif // SAMBALOGGER_H
