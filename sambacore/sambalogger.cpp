#include "sambalogger.h"
#include <QDate>

class SambaLoggerEntry
{
public:
	SambaLoggerEntry(const QString& subsystem, const QString& message)
		: m_date(QDateTime::currentDateTime()), m_subsystem(subsystem), m_message(message) { }

	const QDateTime &date() { return m_date; }

	const QString &subsystem() { return m_subsystem; }

	const QString &message() { return m_message; }

private:
	QDateTime m_date;
	QString m_subsystem;
	QString m_message;
};

SambaLogger *SambaLogger::_instance = NULL;

SambaLogger::SambaLogger()
{

}

SambaLogger::~SambaLogger()
{
	SambaLoggerEntry *entry;
	foreach (entry, m_entries)
		delete entry;
	m_entries.clear();
}

SambaLogger *SambaLogger::getInstance()
{
	if (!_instance)
		_instance = new SambaLogger();
	return _instance;
}

void SambaLogger::append(const QString& message)
{
	append(QString(), message);
}

void SambaLogger::append(const QString& subsystem, const QString& message)
{
	m_entries.append(new SambaLoggerEntry(subsystem, message));
	emit textChanged();
}

QString SambaLogger::text() const
{
	QString text;
	SambaLoggerEntry *entry;
	foreach (entry, m_entries) {
		text.append(entry->date().date().toString("yyyy/MM/dd"));
		text.append("&nbsp;");
		text.append(entry->date().time().toString("HH:mm:ss.zzz"));
		text.append("&nbsp;");
		if (entry->subsystem().length() > 0)
		{
			text.append("<b>");
			text.append(entry->subsystem());
			text.append("</b>");
			text.append("&nbsp;");
		}
		text.append(entry->message());
		text.append("<br/>");
	}
	return text;
}
