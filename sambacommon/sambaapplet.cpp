#include "sambaapplet.h"

SambaApplet::SambaApplet(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name(""),
	  m_description(""),
	  m_kind(KindOther),
	  m_codeUrl(""),
	  m_codeAddr(0),
	  m_mailboxAddr(0),
	  m_memorySize(0),
	  m_bufferAddr(0),
	  m_bufferSize(0),
	  m_commands(QVariant()),
	  m_initArgs(QVariant())
{
}

QString SambaApplet::name() const
{
	return m_name;
}

void SambaApplet::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QString SambaApplet::description() const
{
	return m_description;
}

void SambaApplet::setDescription(const QString& description)
{
	m_description = description;
	emit descriptionChanged();
}

SambaApplet::AppletKind SambaApplet::kind() const
{
	return m_kind;
}

void SambaApplet::setKind(AppletKind kind)
{
	m_kind = kind;
	emit kindChanged();
}

QString SambaApplet::codeUrl() const
{
	return m_codeUrl;
}

void SambaApplet::setCodeUrl(const QString& codeUrl)
{
	m_codeUrl = codeUrl;
	emit codeUrlChanged();
}

quint32 SambaApplet::codeAddr() const
{
	return m_codeAddr;
}

void SambaApplet::setCodeAddr(quint32 codeAddr)
{
	m_codeAddr = codeAddr;
	emit codeAddrChanged();
}

quint32 SambaApplet::mailboxAddr() const
{
	return m_mailboxAddr;
}

void SambaApplet::setMailboxAddr(quint32 mailboxAddr)
{
	m_mailboxAddr = mailboxAddr;
	emit mailboxAddrChanged();
}

quint32 SambaApplet::memorySize() const
{
	return m_memorySize;
}

void SambaApplet::setMemorySize(quint32 memorySize)
{
	m_memorySize = memorySize;
	emit memorySizeChanged();
}

quint32 SambaApplet::bufferAddr() const
{
	return m_bufferAddr;
}

void SambaApplet::setBufferAddr(quint32 bufferAddr)
{
	m_bufferAddr = bufferAddr;
	emit bufferAddrChanged();
}

quint32 SambaApplet::bufferSize() const
{
	return m_bufferSize;
}

void SambaApplet::setBufferSize(quint32 bufferSize)
{
	m_bufferSize = bufferSize;
	emit bufferSizeChanged();
}

QVariant SambaApplet::commands() const
{
	return m_commands;
}

void SambaApplet::setCommands(const QVariant& commands)
{
	m_commands = commands;
	emit commandsChanged();
}

bool SambaApplet::hasCommand(const QString& name)
{
	QJSValue commands = m_commands.value<QJSValue>();
	if (!commands.hasProperty(name))
		return false;

	QJSValue command = commands.property(name);
	if (!command.isNumber())
		return false;

	return true;
}

quint32 SambaApplet::command(const QString& name)
{
	QJSValue commands = m_commands.value<QJSValue>();
	if (!commands.hasProperty(name))
		return 0xffffffff;

	QJSValue command = commands.property(name);
	if (!command.isNumber())
		return 0xffffffff;

	return command.toUInt();
}

QVariant SambaApplet::initArgs() const
{
	return m_initArgs;
}

void SambaApplet::setInitArgs(const QVariant& initArgs)
{
	m_initArgs = initArgs;
	emit initArgsChanged();
}
