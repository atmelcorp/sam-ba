#ifndef SAMBASCRIPTCONTEXT_H
#define SAMBASCRIPTCONTEXT_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaScriptContext : public QObject
{
	Q_OBJECT
	Q_PROPERTY(QStringList arguments READ arguments NOTIFY argumentsChanged)
	Q_PROPERTY(int returnCode READ returnCode WRITE setReturnCode NOTIFY returnCodeChanged)

public:
	SambaScriptContext(QObject* parent = 0)
	    : QObject(parent),
	      m_returnCode(0)
	{
	}

	void setArguments(const QStringList& arguments) {
		m_arguments = arguments;
		emit argumentsChanged();
	}

	QStringList arguments() const {
		return m_arguments;
	}

	int returnCode() const {
		return m_returnCode;
	}

	void setReturnCode(int returnCode)
	{
		m_returnCode = returnCode;
		emit returnCodeChanged();
	}

signals:
	void argumentsChanged();
	void returnCodeChanged();

private:
	QStringList m_arguments;
	int m_returnCode;
};

#endif // SAMBASCRIPTCONTEXT_H
