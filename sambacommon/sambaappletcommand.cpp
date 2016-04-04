#include "sambaappletcommand.h"

SambaAppletCommand::SambaAppletCommand(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name(""),
	  m_code(0),
	  m_timeout(0)
{
}

QString SambaAppletCommand::name() const
{
	return m_name;
}

void SambaAppletCommand::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

quint32 SambaAppletCommand::code() const
{
	return m_code;
}

void SambaAppletCommand::setCode(quint32 code)
{
	m_code = code;
	emit codeChanged();
}

quint32 SambaAppletCommand::timeout() const
{
	return m_timeout;
}

void SambaAppletCommand::setTimeout(quint32 timeout)
{
	m_timeout = timeout;
	emit timeoutChanged();
}

