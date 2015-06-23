#ifndef SAMBA_CONNECTION_PORT_SERIAL_H
#define SAMBA_CONNECTION_PORT_SERIAL_H

#include "sambaconnectionport.h"
#include <QSerialPort>

class Q_DECL_EXPORT SambaConnectionPortSerial : public SambaConnectionPort
{
public:
	SambaConnectionPortSerial(QObject *parent, const QSerialPortInfo &info, bool at91);
	~SambaConnectionPortSerial();

	// General
	bool connect();
	void disconnect();

	// Memory read
	quint8 readu8(quint32 address);
	quint16 readu16(quint32 address);
	quint32 readu32(quint32 address);
	QByteArray read(quint32 address, int length);

	// Memory write
	bool writeu8(quint32 address, quint8 data);
	bool writeu16(quint32 address, quint16 data);
	bool writeu32(quint32 address, quint32 data);
	bool write(quint32 address, const QByteArray &data);

	// Execute
	bool go(quint32 address);

protected:
	virtual quint32 appletCommType();

private:
	void writeSerial(const QString &str);
	void writeSerial(const QByteArray &data);
	QByteArray readAllSerial();

private:
	bool m_at91;
	QSerialPort m_serial;
};

#endif // SAMBA_CONNECTION_PORT_SERIAL_H
