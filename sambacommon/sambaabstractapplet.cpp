#include "sambaabstractapplet.h"

SambaAbstractApplet::SambaAbstractApplet(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name(""),
	  m_description(""),
	  m_codeUrl(""),
	  m_codeAddr(0),
	  m_mailboxAddr(0),
	  m_traceLevel(5),
	  m_retries(20),
	  m_commands(QVariant()),
	  m_bufferAddr(0),
	  m_bufferSize(0),
	  m_bufferPages(0),
	  m_pageSize(0),
	  m_memorySize(0),
	  m_memoryPages(0),
	  m_eraseSupport(0),
	  m_paddingByte(0xff)
{
}

QString SambaAbstractApplet::name() const
{
	return m_name;
}

void SambaAbstractApplet::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QString SambaAbstractApplet::description() const
{
	return m_description;
}

void SambaAbstractApplet::setDescription(const QString& description)
{
	m_description = description;
	emit descriptionChanged();
}

QString SambaAbstractApplet::codeUrl() const
{
	return m_codeUrl;
}

void SambaAbstractApplet::setCodeUrl(const QString& codeUrl)
{
	m_codeUrl = codeUrl;
	emit codeUrlChanged();
}

quint32 SambaAbstractApplet::codeAddr() const
{
	return m_codeAddr;
}

void SambaAbstractApplet::setCodeAddr(quint32 codeAddr)
{
	m_codeAddr = codeAddr;
	emit codeAddrChanged();
}

quint32 SambaAbstractApplet::mailboxAddr() const
{
	return m_mailboxAddr;
}

void SambaAbstractApplet::setMailboxAddr(quint32 mailboxAddr)
{
	m_mailboxAddr = mailboxAddr;
	emit mailboxAddrChanged();
}

quint32 SambaAbstractApplet::retries() const
{
	return m_retries;
}

void SambaAbstractApplet::setRetries(quint32 retries)
{
	m_retries = retries;
	emit retriesChanged();
}

QVariant SambaAbstractApplet::commands() const
{
	return m_commands;
}

void SambaAbstractApplet::setCommands(const QVariant& commands)
{
	m_commands = commands;
	emit commandsChanged();
}

bool SambaAbstractApplet::hasCommand(const QString& name) const
{
	QJSValue commands = m_commands.value<QJSValue>();
	if (!commands.hasProperty(name))
		return false;

	QJSValue command = commands.property(name);
	if (!command.isNumber())
		return false;

	return true;
}

quint32 SambaAbstractApplet::command(const QString& name) const
{
	QJSValue commands = m_commands.value<QJSValue>();
	if (!commands.hasProperty(name))
		return 0xffffffff;

	QJSValue command = commands.property(name);
	if (!command.isNumber())
		return 0xffffffff;

	return command.toUInt();
}

quint32 SambaAbstractApplet::traceLevel() const
{
	return m_traceLevel;
}

void SambaAbstractApplet::setTraceLevel(quint32 traceLevel)
{
	m_traceLevel = traceLevel;
	emit traceLevelChanged();
}

quint32 SambaAbstractApplet::bufferAddr() const
{
	return m_bufferAddr;
}

void SambaAbstractApplet::setBufferAddr(quint32 bufferAddr)
{
	m_bufferAddr = bufferAddr;
	emit bufferAddrChanged();
}

quint32 SambaAbstractApplet::bufferSize() const
{
	return m_bufferSize;
}

void SambaAbstractApplet::setBufferSize(quint32 bufferSize)
{
	m_bufferSize = bufferSize;
	emit bufferSizeChanged();

	if (m_pageSize > 0 && (m_bufferSize != (m_bufferPages * m_pageSize))) {
		m_bufferPages = m_bufferSize / m_pageSize;
		emit bufferPagesChanged();
	}
}

quint32 SambaAbstractApplet::bufferPages() const
{
	return m_bufferPages;
}

void SambaAbstractApplet::setBufferPages(quint32 bufferPages)
{
	m_bufferPages = bufferPages;
	emit bufferPagesChanged();

	if (m_pageSize > 0 && (m_bufferSize != (m_bufferPages * m_pageSize))) {
		m_bufferSize = m_bufferPages * m_pageSize;
		emit bufferSizeChanged();
	}
}

quint32 SambaAbstractApplet::pageSize() const
{
	return m_pageSize;
}

void SambaAbstractApplet::setPageSize(quint32 pageSize)
{
	m_pageSize = pageSize;
	emit pageSizeChanged();

	if (m_bufferSize != (m_bufferPages * m_pageSize)) {
		if (m_bufferSize > 0) {
			m_bufferPages = m_bufferSize / m_pageSize;
			emit bufferPagesChanged();
		} else if (m_bufferPages > 0) {
			m_bufferSize = m_bufferPages * m_pageSize;
			emit bufferSizeChanged();
		}
	}

	if (m_memorySize != (m_memoryPages * m_pageSize)) {
		if (m_memorySize > 0) {
			m_memoryPages = m_memorySize / m_pageSize;
			emit memoryPagesChanged();
		} else if (m_memoryPages > 0) {
			m_memorySize = m_memoryPages * m_pageSize;
			emit memorySizeChanged();
		}
	}
}

quint32 SambaAbstractApplet::memorySize() const
{
	return m_memorySize;
}

void SambaAbstractApplet::setMemorySize(quint32 memorySize)
{
	m_memorySize = memorySize;
	emit memorySizeChanged();

	if (m_pageSize > 0 && (m_memorySize != (m_memoryPages * m_pageSize))) {
		m_memoryPages = m_memorySize / m_pageSize;
		emit memoryPagesChanged();
	}
}

quint32 SambaAbstractApplet::memoryPages() const
{
	return m_memoryPages;
}

void SambaAbstractApplet::setMemoryPages(quint32 memoryPages)
{
	m_memoryPages = memoryPages;
	emit memoryPagesChanged();

	if (m_pageSize > 0 && (m_memorySize != (m_memoryPages * m_pageSize))) {
		m_memorySize = m_memoryPages * m_pageSize;
		emit memorySizeChanged();
	}
}

quint32 SambaAbstractApplet::eraseSupport() const
{
	return m_eraseSupport;
}

void SambaAbstractApplet::setEraseSupport(quint32 eraseSupport)
{
	m_eraseSupport = eraseSupport;
	emit eraseSupportChanged();
}

quint8 SambaAbstractApplet::paddingByte() const
{
	return m_paddingByte;
}

void SambaAbstractApplet::setPaddingByte(quint8 paddingByte)
{
	m_paddingByte = paddingByte;
	emit paddingByteChanged();
}
