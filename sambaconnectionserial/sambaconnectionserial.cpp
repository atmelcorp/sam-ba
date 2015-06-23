#include "sambaconnectionserial.h"
#include "sambaconnectionportserial.h"
#include <QSerialPort>
#include <QSerialPortInfo>
#include <QStringList>

#define ATMEL_USB_VID 0x03eb
#define SAMBA_USB_PID 0x6124

SambaConnectionSerial::SambaConnectionSerial(QObject* parent, bool at91)
	: SambaConnection(parent), m_at91(at91)
{
	m_tag = at91 ? "at91" : "serial";
	m_name = at91 ? "AT91 USB" : "Serial";
	m_description = m_name;
}

SambaConnectionSerial::~SambaConnectionSerial()
{

}

void SambaConnectionSerial::refreshPorts()
{
	// TODO keep unchanged ports

	m_ports.clear();

	QSerialPortInfo info;
	foreach (info, QSerialPortInfo::availablePorts()) {
		if (info.hasVendorIdentifier()
			&& info.vendorIdentifier() == ATMEL_USB_VID
			&& info.hasProductIdentifier()
			&& info.productIdentifier() == SAMBA_USB_PID)
		{
			if (m_at91)
				m_ports.append(new SambaConnectionPortSerial(this, info, m_at91));
		}
		else
		{
			if (!m_at91)
				m_ports.append(new SambaConnectionPortSerial(this, info, m_at91));
		}
	}

	emit portsChanged();
}
