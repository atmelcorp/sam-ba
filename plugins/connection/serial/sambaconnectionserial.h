#ifndef SAMBA_CONNECTION_SERIAL_H
#define SAMBA_CONNECTION_SERIAL_H

#include <sambabytearray.h>
#include <QObject>
#include <QLoggingCategory>
#include <QSerialPort>
#include <QtQml>

Q_DECLARE_LOGGING_CATEGORY(sambaLogConnSerial)

class Q_DECL_EXPORT SambaConnectionSerial : public QObject
{
	Q_OBJECT

public:
	SambaConnectionSerial(QObject *parent = 0);
	~SambaConnectionSerial();

	// Ports
	Q_INVOKABLE QStringList availablePorts();

	// Connection
	Q_INVOKABLE bool open(const QString& port, qint32 baudRate);
	Q_INVOKABLE void close();
	Q_INVOKABLE bool isUSB();

	// Memory read
	Q_INVOKABLE quint8 readu8(quint32 address);
	Q_INVOKABLE quint16 readu16(quint32 address);
	Q_INVOKABLE quint32 readu32(quint32 address);
	Q_INVOKABLE qint8 reads8(quint32 address);
	Q_INVOKABLE qint16 reads16(quint32 address);
	Q_INVOKABLE qint32 reads32(quint32 address);
	Q_INVOKABLE SambaByteArray* read(quint32 address, int length);

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
		qmlRegisterType<SambaConnectionSerial>(uri, 1, 0, "SerialConnectionHelper");
	}
};

#endif // SAMBA_CONNECTION_SERIAL_H
