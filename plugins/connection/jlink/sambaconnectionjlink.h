#ifndef SAMBA_CONNECTION_JLINK_H
#define SAMBA_CONNECTION_JLINK_H

#include <sambabytearray.h>
#include <QObject>
#include <QLoggingCategory>
#include <QtQml>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnJlink)

class Q_DECL_EXPORT SambaConnectionJlink : public QObject
{
	Q_OBJECT

public:
	SambaConnectionJlink(QObject *parent = 0);
	~SambaConnectionJlink();

	// Ports
	Q_INVOKABLE QStringList availablePorts();

	// Connection
	Q_INVOKABLE bool open(const QString& portName, bool swd);
	Q_INVOKABLE void close();

	// Memory read
	Q_INVOKABLE quint8 readu8(quint32 address);
	Q_INVOKABLE quint16 readu16(quint32 address);
	Q_INVOKABLE quint32 readu32(quint32 address);
	Q_INVOKABLE qint8 reads8(quint32 address);
	Q_INVOKABLE qint16 reads16(quint32 address);
	Q_INVOKABLE qint32 reads32(quint32 address);
	Q_INVOKABLE SambaByteArray *read(quint32 address, int length);

	// Memory write
	Q_INVOKABLE bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE bool writes8(quint32 address, qint8 data);
	Q_INVOKABLE bool writes16(quint32 address, qint16 data);
	Q_INVOKABLE bool writes32(quint32 address, qint32 data);
	Q_INVOKABLE bool write(quint32 address, SambaByteArray *data);

	// Execute
	Q_INVOKABLE bool go(quint32 address);

signals:
	void connectionOpened();
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	int m_devFamily, m_device;
};

class Q_DECL_EXPORT SambaConnectionPluginJlink : public QQmlExtensionPlugin
{
	Q_OBJECT

	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri)
	{
		Q_ASSERT(uri == QLatin1String("SAMBA.Connection.JLink"));
		qmlRegisterType<SambaConnectionJlink>(uri, 1, 0, "JLinkConnectionHelper");
	}
};

#endif // SAMBA_CONNECTION_JLINK_H
