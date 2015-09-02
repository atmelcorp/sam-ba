#include "sambacore.h"
#include "sambaconnectionport.h"

SambaConnectionPort::SambaConnectionPort(QObject *parent)
	: SambaObject(parent),
	  m_retries(7),
	  m_traceLevel(0),
	  m_appletTraceLevel(4),
	  m_currentApplet(NULL)
{
}

SambaConnectionPort::~SambaConnectionPort()
{

}

SambaApplet *SambaConnectionPort::currentApplet() const
{
	return m_currentApplet;
}

void SambaConnectionPort::writeApplet(SambaApplet *applet)
{
	qCInfo(sambaLogApplet, "Loading applet '%s'", applet->name().toLatin1().constData());

	if (m_currentApplet)
	{
		m_currentApplet->setLoaded(false);
		m_currentApplet = NULL;
		emit currentAppletChanged();
	}

	// TODO add error checking
	QUrl url(applet->fileName());
	QFile file(url.toLocalFile());
	file.open(QIODevice::ReadOnly);
	QByteArray data = file.readAll();
	file.close();
	write(applet->appletAddress(), data);

	applet->setLoaded(true);;
	m_currentApplet = applet;
	emit currentAppletChanged();
}

quint32 SambaConnectionPort::readMailbox(int index)
{
	return readu32(m_currentApplet->mailboxAddress() + (index + 2) * 4);
}

qint32 SambaConnectionPort::executeApplet(quint32 cmd, quint32 arg0, quint32 arg1, quint32 arg2, quint32 arg3, quint32 arg4)
{
	quint32 mailboxArgsOffset = 8;

	// write applet command / status
	writeu32(m_currentApplet->mailboxAddress(), cmd);
	writeu32(m_currentApplet->mailboxAddress() + 4, 0xffffffff);

	// write comm type / trace level if command is "Initialize"
	if (cmd == SambaApplet::CmdInit)
	{
		writeu32(m_currentApplet->mailboxAddress() + 8, appletCommType());
		writeu32(m_currentApplet->mailboxAddress() + 12, m_appletTraceLevel);
		mailboxArgsOffset = 16;
	}

	// write applet arguments
	writeu32(m_currentApplet->mailboxAddress() + mailboxArgsOffset, arg0);
	writeu32(m_currentApplet->mailboxAddress() + mailboxArgsOffset + 4, arg1);
	writeu32(m_currentApplet->mailboxAddress() + mailboxArgsOffset + 8, arg2);
	writeu32(m_currentApplet->mailboxAddress() + mailboxArgsOffset + 12, arg3);
	writeu32(m_currentApplet->mailboxAddress() + mailboxArgsOffset + 16, arg4);

	// run applet
	go(m_currentApplet->appletAddress());

	// wait for completion
	quint32 maxRetries = m_retries;
	quint32 retries = 0;
	int delay = 50;
	while (retries < maxRetries)
	{
		quint32 ack = readu32(m_currentApplet->mailboxAddress());
		if (ack == ~cmd)
			break;

		qCDebug(sambaLogApplet, "Applet %s command %u did not complete, waiting %dms",
			   m_currentApplet->name().toLatin1().constData(), cmd, delay);

		QThread::msleep(delay);

		retries++;
		delay *= 2;
	}

	if (retries == maxRetries)
	{
		qCCritical(sambaLogApplet, "Error: applet %s command %u did not complete in time",
			   m_currentApplet->name().toLatin1().constData(), cmd);
		return -1;
	}

	// return applet status
	qint32 status = reads32(m_currentApplet->mailboxAddress() + 4);
	if (cmd == SambaApplet::CmdInit &&
		status == SambaApplet::StatusSuccess)
	{
		quint32 memorySize = 0;
		quint32 bufferAddress = 0;
		quint32 bufferSize = 0;

		if (m_currentApplet->kind() == SambaApplet::NVM ||
			m_currentApplet->kind() == SambaApplet::Extram)
		{
			memorySize = readMailbox(0);
			bufferAddress = readMailbox(1);
			bufferSize = readMailbox(2);
		}

		m_currentApplet->setInitialized(memorySize, bufferAddress, bufferSize);
	}

	return status;
}

bool SambaConnectionPort::executeAppletRead(quint32 offset, quint32 size, const QString& fileName)
{
	QFile file(fileName);

	if (!file.open(QIODevice::WriteOnly))
	{
		qCCritical(sambaLogApplet, "Error: Could not open file '%s' for writing", fileName.toLatin1().constData());
		return false;
	}

	if (offset + size > m_currentApplet->memorySize())
	{
		quint32 remaining = m_currentApplet->memorySize() - offset;
		qCCritical(sambaLogApplet, "Error: trying to read past end of memory, only %d bytes remaining at offset 0x%08x (file size is %d)",
			   remaining, offset, size);
		return false;
	}

	while (size > 0)
	{
		qint32 count = std::min(size, m_currentApplet->bufferSize());

		if (executeApplet(SambaApplet::CmdRead, m_currentApplet->bufferAddress(),
						  count, offset) != SambaApplet::StatusSuccess)
			break;

		QByteArray data = read(m_currentApplet->bufferAddress(), count);
		if (data.size() < count)
			break;

		if (file.write(data) != count)
			break;

		qCInfo(sambaLogApplet, "Read %d bytes at address 0x%08x", count, offset);

		offset += count;
		size -= count;
	};

	file.close();
	return size == 0;
}

bool SambaConnectionPort::executeAppletWrite(quint32 offset, const QString& fileName)
{
	QFile file(fileName);

	if (!file.open(QIODevice::ReadOnly))
	{
		qCCritical(sambaLogApplet, "Error: Could not open file '%s' for reading", fileName.toLatin1().constData());
		return false;
	}

	quint32 size = (quint32)file.size();

	if (offset + size > m_currentApplet->memorySize())
	{
		quint32 remaining = m_currentApplet->memorySize() - offset;
		qCCritical(sambaLogApplet, "Error: trying to write past end of memory, only %d bytes remaining at offset %08x (file size is %d)",
			   remaining, offset, size);
		return false;
	}

	while (size > 0)
	{
		qint32 count = std::min(size, m_currentApplet->bufferSize());

		QByteArray data = file.read(count);
		if (data.size() == 0)
			break;

		if (!write(m_currentApplet->bufferAddress(), data))
			break;

		if (executeApplet(SambaApplet::CmdWrite, m_currentApplet->bufferAddress(),
						  data.size(), offset) != SambaApplet::StatusSuccess)
			break;

		qCInfo(sambaLogApplet, "Wrote %d bytes at address 0x%08x", count, offset);

		offset += data.size();
		size -= data.size();
	};

	file.close();
	return size == 0;
}
