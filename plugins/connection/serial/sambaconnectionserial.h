#ifndef SAMBA_CONNECTION_SERIAL_H
#define SAMBA_CONNECTION_SERIAL_H

#include <sambaconnection.h>
#include <QLoggingCategory>
#include <QSerialPort>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnSerial)

class Q_DECL_EXPORT SambaConnectionSerial : public SambaConnection
{
	Q_OBJECT
	Q_PROPERTY(quint32 baudRate READ baudRate WRITE setBaudRate NOTIFY baudRateChanged)

public:
	SambaConnectionSerial(QQuickItem *parent = 0);
	~SambaConnectionSerial();

	quint32 baudRate() {
		return m_baudRate;
	}
	void setBaudRate(quint32 baudRate) {
		m_baudRate = baudRate;
		emit baudRateChanged();
	}

	Q_INVOKABLE QStringList availablePorts();

	quint32 type();

	Q_INVOKABLE void open();
	Q_INVOKABLE void close();

	Q_INVOKABLE quint8 readu8(quint32 address);
	Q_INVOKABLE quint16 readu16(quint32 address);
	Q_INVOKABLE quint32 readu32(quint32 address);
	Q_INVOKABLE SambaByteArray* read(quint32 address, unsigned length);

	Q_INVOKABLE bool writeu8(quint32 address, quint8 data);
	Q_INVOKABLE bool writeu16(quint32 address, quint16 data);
	Q_INVOKABLE bool writeu32(quint32 address, quint32 data);
	Q_INVOKABLE bool write(quint32 address, SambaByteArray *data);

	Q_INVOKABLE bool go(quint32 address);

signals:
	void baudRateChanged();
	void connectionOpened();
	void connectionFailed(const QString& message);
	void connectionClosed();

private:
	void writeSerial(const QString &str);
	void writeSerial(const QByteArray &data);
	QByteArray readAllSerial();

private:
	bool m_at91;
	qint32 m_baudRate;
	QSerialPort m_serial;
};

class Q_DECL_EXPORT SambaConnectionSerialPlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri)
	{
		Q_ASSERT(uri == QLatin1String("SAMBA.Connection.Serial"));
		qmlRegisterType<SambaConnectionSerial>(uri, 1, 0, "SerialConnection");
	}
};

#endif // SAMBA_CONNECTION_SERIAL_H
