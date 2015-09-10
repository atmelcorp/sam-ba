#ifndef SAMBA_CONNECTION_JLINK_H
#define SAMBA_CONNECTION_JLINK_H

#include <sambaconnection.h>
#include <QLoggingCategory>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnJlink)

class Q_DECL_EXPORT SambaConnectionJlink : public SambaConnection
{
	Q_OBJECT
	Q_PROPERTY(bool swd READ swd WRITE setSWD NOTIFY swdChanged)

public:
	SambaConnectionJlink(QQuickItem *parent = 0);
	~SambaConnectionJlink();

	bool swd() {
		return m_swd;
	}
	void setSWD(bool swd) {
		m_swd = swd;
		emit swdChanged();
	}

	Q_INVOKABLE QStringList availablePorts();

	quint32 type();

	Q_INVOKABLE void open();
	Q_INVOKABLE void close();

	Q_INVOKABLE quint8 readu8(quint32 address);
	Q_INVOKABLE quint16 readu16(quint32 address);
	Q_INVOKABLE quint32 readu32(quint32 address);
	Q_INVOKABLE SambaByteArray *read(quint32 address, unsigned length);

	Q_INVOKABLE bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE bool write(quint32 address, SambaByteArray *data);

	Q_INVOKABLE bool go(quint32 address);

signals:
	void swdChanged();
	void connectionOpened();
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	bool m_swd;
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
		qmlRegisterType<SambaConnectionJlink>(uri, 1, 0, "JLinkConnection");
	}
};

#endif // SAMBA_CONNECTION_JLINK_H
