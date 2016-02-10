#include "sambaconnection.h"
#include <QStringList>

SambaConnection::SambaConnection(QQuickItem* parent)
	: QQuickItem(parent),
	  m_port(""),
	  m_applet(0)
{
}

SambaConnection::~SambaConnection()
{
	close();
}

QString SambaConnection::port()
{
	return m_port;
}

void SambaConnection::setPort(const QString& port)
{
	if (m_port != port)
	{
		m_port = port;
		emit portChanged();
	}
}

SambaAbstractApplet* SambaConnection::applet()
{
	return m_applet;
}

QStringList SambaConnection::availablePorts()
{
	return QStringList();
}

void SambaConnection::open()
{
	emit connectionFailed("Cannot open connection");
}

void SambaConnection::close()
{
	emit connectionClosed();
}

quint8 SambaConnection::readu8(quint32 address)
{
	Q_UNUSED(address)
	return 0;
}

quint16 SambaConnection::readu16(quint32 address)
{
	Q_UNUSED(address)
	return 0;
}

quint32 SambaConnection::readu32(quint32 address)
{
	Q_UNUSED(address)
	return 0;
}

qint8 SambaConnection::reads8(quint32 address)
{
	quint8 data = readu8(address);
	return *reinterpret_cast<qint8*>(&data);
}

qint16 SambaConnection::reads16(quint32 address)
{
	quint16 data = readu16(address);
	return *reinterpret_cast<qint16*>(&data);
}

qint32 SambaConnection::reads32(quint32 address)
{
	quint32 data = readu32(address);
	return *reinterpret_cast<qint32*>(&data);
}

SambaByteArray *SambaConnection::read(quint32 address, unsigned length)
{
	Q_UNUSED(address)
	Q_UNUSED(length)
	return new SambaByteArray();
}

bool SambaConnection::writeu8(quint32 address, quint8 data)
{
	Q_UNUSED(address)
	Q_UNUSED(data)
	return false;
}

bool SambaConnection::writeu16(quint32 address, quint16 data)
{
	Q_UNUSED(address)
	Q_UNUSED(data)
	return false;
}

bool SambaConnection::writeu32(quint32 address, quint32 data)
{
	Q_UNUSED(address)
	Q_UNUSED(data)
	return false;
}

bool SambaConnection::writes8(quint32 address, qint8 data)
{
	return writeu8(address, *(reinterpret_cast<quint8*>(&data)));
}

bool SambaConnection::writes16(quint32 address, qint16 data)
{
	return writeu16(address, *(reinterpret_cast<quint16*>(&data)));
}

bool SambaConnection::writes32(quint32 address, qint32 data)
{
	return writeu32(address, *(reinterpret_cast<quint32*>(&data)));
}

bool SambaConnection::write(quint32 address, SambaByteArray *data)
{
	Q_UNUSED(address)
	Q_UNUSED(data)
	return false;
}

bool SambaConnection::go(quint32 address)
{
	Q_UNUSED(address)
	return false;
}

quint32 SambaConnection::appletConnectionType()
{
	return Serial;
}

bool SambaConnection::appletUpload(SambaAbstractApplet* applet)
{
	m_applet = NULL;
	emit appletChanged();

	SambaByteArray appletCode;
	if (!appletCode.readUrl(applet->codeUrl()))
		return false;

	if (write(applet->codeAddr(), &appletCode))
	{
		m_applet = applet;
		emit appletChanged();
		return true;
	}

	return false;
}

quint32 SambaConnection::appletMailboxRead(quint32 index)
{
	if (!m_applet || index > 32)
		return 0;
	return readu32(m_applet->mailboxAddr() + (index + 2) * 4);
}

SambaByteArray* SambaConnection::appletBufferRead(unsigned length)
{
	if (!m_applet)
		return NULL;
	if (length > m_applet->bufferSize())
		return NULL;
	return read(m_applet->bufferAddr(), length);
}

bool SambaConnection::appletBufferWrite(SambaByteArray* data)
{
	if (!m_applet)
		return false;
	if (data->length() > m_applet->bufferSize())
		return false;
	return write(m_applet->bufferAddr(), data);
}

qint32 SambaConnection::appletExecute(const QString& cmd, QVariant args, quint32 retries)
{
	if (!m_applet)
		return -1;
	if (!m_applet->hasCommand(cmd))
		return -1;

	quint32 cmdValue = m_applet->command(cmd);
	int mbxOffset = 0;

	// write applet command / status
	writeu32(m_applet->mailboxAddr() + mbxOffset, cmdValue);
	mbxOffset += 4;
	writeu32(m_applet->mailboxAddr() + mbxOffset, 0xffffffff);
	mbxOffset += 4;

	// write applet arguments
	if (args.canConvert(QVariant::UInt))
	{
		writeu32(m_applet->mailboxAddr() + mbxOffset, args.toUInt());
		mbxOffset += 4;
	}
	else
	{
		QJSValue jsArgs = args.value<QJSValue>();
		if (jsArgs.isArray())
		{
			QJSValueIterator it(jsArgs);
			while (it.hasNext()) {
				it.next();
				if (it.value().isNumber())
				{
					writeu32(m_applet->mailboxAddr() + mbxOffset, it.value().toUInt());
					mbxOffset += 4;
				}
				else
				{
					// error
				}
			}
		}
		else
		{
			// error
		}
	}

	// run applet
	go(m_applet->codeAddr());

	// wait for completion
	float delay = 100;
	unsigned retry = 0;
	for (retry = 0; retry < retries; retry++)
	{
		if (retry > 0)
		{
			QThread::usleep(delay);
			delay *= 1.5;
		}

		quint32 ack = readu32(m_applet->mailboxAddr());
		if (ack == (0xffffffff - cmdValue))
			break;
	}
	if (retry == retries)
		return -1;

	// return applet status
	return reads32(m_applet->mailboxAddr() + 4);
}
