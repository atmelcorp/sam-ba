#ifndef SAMBA_CONNECTION_H
#define SAMBA_CONNECTION_H

#include <sambacommon.h>
#include <sambaabstractapplet.h>
#include <sambabytearray.h>
#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SAMBACOMMONSHARED_EXPORT SambaConnection : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString port READ port WRITE setPort NOTIFY portChanged)
	Q_PROPERTY(SambaAbstractApplet* applet READ applet NOTIFY appletChanged)
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

	SambaAbstractApplet* applet();

	Q_INVOKABLE virtual QStringList availablePorts();

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

	Q_INVOKABLE virtual quint32 appletConnectionType();
	Q_INVOKABLE virtual bool appletUpload(SambaAbstractApplet* applet);
	Q_INVOKABLE virtual quint32 appletMailboxRead(quint32 index);
	Q_INVOKABLE virtual SambaByteArray* appletBufferRead(unsigned length);
	Q_INVOKABLE virtual bool appletBufferWrite(SambaByteArray* data);
	Q_INVOKABLE virtual qint32 appletExecute(const QString &cmd, QVariant args, quint32 retries);

signals:
	void portChanged();
	void appletChanged();
	void connectionOpened();
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	QString m_port;
	SambaAbstractApplet* m_applet;
};

#endif // SAMBA_CONNECTION_H
