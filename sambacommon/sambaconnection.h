#ifndef SAMBA_CONNECTION_H
#define SAMBA_CONNECTION_H

#include <sambabytearray.h>
#include <sambaapplet.h>
#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SambaConnection : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString port READ port WRITE setPort NOTIFY portChanged)
	Q_PROPERTY(SambaApplet* applet READ applet NOTIFY appletChanged)
	Q_PROPERTY(quint32 appletTraceLevel READ appletTraceLevel WRITE setAppletTraceLevel NOTIFY appletTraceLevelChanged)
	Q_PROPERTY(int appletRetries READ appletRetries WRITE setAppletRetries NOTIFY appletRetriesChanged)
	Q_ENUMS(ConnectionType)

public:
	enum ConnectionType {
		USB = 0x00000000,
		Serial = 0x00000001,
		JTAG = 0x00000002,
	};

	SambaConnection(QQuickItem *parent = 0);
	~SambaConnection();

	QString port();
	void setPort(const QString& port);

	SambaApplet* applet();

	quint32 appletTraceLevel();
	void setAppletTraceLevel(quint32 traceLevel);

	int appletRetries();
	void setAppletRetries(int retries);

	Q_INVOKABLE virtual QStringList availablePorts();

	virtual quint32 type();

	Q_INVOKABLE virtual void open();
	Q_INVOKABLE virtual void close();

	Q_INVOKABLE virtual quint8 readu8(quint32 address);
	Q_INVOKABLE virtual quint16 readu16(quint32 address);
	Q_INVOKABLE virtual quint32 readu32(quint32 address);
	Q_INVOKABLE virtual qint8 reads8(quint32 address);
	Q_INVOKABLE virtual qint16 reads16(quint32 address);
	Q_INVOKABLE virtual qint32 reads32(quint32 address);
	Q_INVOKABLE virtual SambaByteArray* read(quint32 address, unsigned length);

	Q_INVOKABLE virtual bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE virtual bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE virtual bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE virtual bool writes8(quint32 address, qint8 data);
	Q_INVOKABLE virtual bool writes16(quint32 address, qint16 data);
	Q_INVOKABLE virtual bool writes32(quint32 address, qint32 data);
	Q_INVOKABLE virtual bool write(quint32 address, SambaByteArray *data);

	Q_INVOKABLE virtual bool go(quint32 address);

	Q_INVOKABLE virtual bool appletUpload(SambaApplet* applet);
	Q_INVOKABLE virtual quint32 appletMailboxRead(quint32 index);
	Q_INVOKABLE virtual SambaByteArray* appletBufferRead(unsigned length);
	Q_INVOKABLE virtual bool appletBufferWrite(SambaByteArray* data);
	Q_INVOKABLE virtual qint32 appletExecute(const QString& cmd, QVariant args);

signals:
	void portChanged();
	void appletChanged();
	void appletTraceLevelChanged();
	void appletRetriesChanged();
	void connectionOpened();
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	QString m_port;
	SambaApplet* m_applet;
	quint32 m_appletTraceLevel;
	int m_appletRetries;
};

#endif // SAMBA_CONNECTION_H
