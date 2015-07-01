#ifndef SAMBA_CONNECTION_PORT_H
#define SAMBA_CONNECTION_PORT_H

#include "sambacore_global.h"
#include "sambaobject.h"
#include "sambaapplet.h"
#include <QFile>
#include <QUrl>

class SAMBACORESHARED_EXPORT SambaConnectionPort : public SambaObject
{
	Q_OBJECT

	Q_PROPERTY(quint32 traceLevel READ traceLevel WRITE setTraceLevel NOTIFY traceLevelChanged)
	Q_PROPERTY(quint32 appletTraceLevel READ appletTraceLevel WRITE setAppletTraceLevel NOTIFY appletTraceLevelChanged)
	Q_PROPERTY(SambaApplet *currentApplet READ currentApplet NOTIFY currentAppletChanged)

public:
	explicit SambaConnectionPort(QObject *parent = 0);
	~SambaConnectionPort();

	// General

	quint32 traceLevel() const
	{
		return m_traceLevel;
	}

	void setTraceLevel(quint32 traceLevel)
	{
		m_traceLevel = traceLevel;
		emit traceLevelChanged();
	}

	Q_INVOKABLE virtual bool connect()
	{
		return false;
	}

	Q_INVOKABLE virtual void disconnect()
	{
		// nothing here
	}

	// Memory read

	Q_INVOKABLE virtual QByteArray read(quint32 address, int length)
	{
		Q_UNUSED(address);
		Q_UNUSED(length);
		return QByteArray();
	}

	Q_INVOKABLE virtual quint8 readu8(quint32 address)
	{
		Q_UNUSED(address);
		return 0;
	}

	Q_INVOKABLE virtual quint16 readu16(quint32 address)
	{
		Q_UNUSED(address);
		return 0;
	}

	Q_INVOKABLE virtual quint32 readu32(quint32 address)
	{
		Q_UNUSED(address);
		return 0;
	}

	Q_INVOKABLE virtual qint8 reads8(quint32 address)
	{
		quint8 data = readu8(address);
		return *reinterpret_cast<qint8*>(&data);
	}

	Q_INVOKABLE virtual qint16 reads16(quint32 address)
	{
		quint16 data = readu16(address);
		return *reinterpret_cast<qint16*>(&data);
	}

	Q_INVOKABLE virtual qint32 reads32(quint32 address)
	{
		quint32 data = readu32(address);
		return *reinterpret_cast<qint32*>(&data);
	}

	// Memory write

	Q_INVOKABLE virtual bool writeFromURL(quint32 address, const QString &fileUrl)
	{
		QUrl url(fileUrl);
		QFile file(url.toLocalFile());
		file.open(QIODevice::ReadOnly);
		QByteArray data = file.readAll();
		file.close();
		return write(address, data);
	}

	Q_INVOKABLE virtual bool write(quint32 address, const QByteArray &data)
	{
		Q_UNUSED(address);
		Q_UNUSED(data);
		return false;
	}

	Q_INVOKABLE virtual bool writeu8(quint32 address, quint8 data)
	{
		Q_UNUSED(address);
		Q_UNUSED(data);
		return false;
	}

	Q_INVOKABLE virtual bool writeu16(quint32 address, quint16 data)
	{
		Q_UNUSED(address);
		Q_UNUSED(data);
		return false;
	}

	Q_INVOKABLE virtual bool writeu32(quint32 address, quint32 data)
	{
		Q_UNUSED(address);
		Q_UNUSED(data);
		return false;
	}

	Q_INVOKABLE virtual bool writes8(quint32 address, qint8 data)
	{
		return writeu8(address, *(reinterpret_cast<quint8*>(&data)));
	}

	Q_INVOKABLE virtual bool writes16(quint32 address, qint16 data)
	{
		return writeu16(address, *(reinterpret_cast<quint16*>(&data)));
	}

	Q_INVOKABLE virtual bool writes32(quint32 address, qint32 data)
	{
		return writeu32(address, *(reinterpret_cast<quint32*>(&data)));
	}

	// Execute

	Q_INVOKABLE virtual bool go(quint32 address)
	{
		Q_UNUSED(address);
		return false;
	}

	// Applet Handling

	quint32 appletTraceLevel() const
	{
		return m_appletTraceLevel;
	}

	void setAppletTraceLevel(quint32 appletTraceLevel)
	{
		m_appletTraceLevel = appletTraceLevel;
		emit appletTraceLevelChanged();
	}

	virtual SambaApplet *currentApplet() const;

	Q_INVOKABLE virtual void writeApplet(SambaApplet *applet);

	Q_INVOKABLE virtual quint32 readMailbox(int index);

	Q_INVOKABLE virtual qint32 executeApplet(quint32 cmd,
											 quint32 arg0 = 0,
											 quint32 arg1 = 0,
											 quint32 arg2 = 0,
											 quint32 arg3 = 0,
											 quint32 arg4 = 0);

	Q_INVOKABLE virtual bool executeAppletRead(quint32 offset, quint32 size, const QString& fileName);

	Q_INVOKABLE virtual bool executeAppletWrite(quint32 offset, const QString& fileName);

signals:
	void traceLevelChanged();
	void appletTraceLevelChanged();
	void currentAppletChanged();

protected:
	virtual quint32 appletCommType()
	{
		return SambaApplet::CommSerial;
	}

private:
	quint32 m_traceLevel;
	quint32 m_appletTraceLevel;
	SambaApplet *m_currentApplet;
};

#endif // SAMBA_CONNECTION_PORT_H
