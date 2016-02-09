#include "sambaconnectionjlink.h"
#include <QThread>
#include <QElapsedTimer>
#include <JLinkARMDLL.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(*(x)))

struct atmel_a5_regs {
	const char *name;
	unsigned int cidr;
	unsigned int cidr_mask;
	unsigned int cidr_expected;
	unsigned int wdt_mr;
	unsigned int sfr_l2cc_hramc;
};

/* Register definitions for Atmel Cortex-A5 devices */
/* Order is important: probing stops on first matching device */
static const struct atmel_a5_regs atmel_a5_regs[] = {
	{ "SAMA5D2x", 0xfc069000, 0xffffffe0, 0x8a5c08c0, 0xf8048044, 0xf8030058 },
	{ "SAMA5D4x", 0xfc069040, 0xffffffe0, 0x8a5c07c0, 0xfc068644, 0 },
	{ "SAMA5D3x", 0xffffee40, 0xffffffe0, 0x8a5c07c0, 0xfffffe44, 0 }
};

/* WDT_MR Fields */
#define WDT_MR_WDDIS (1 << 15)

/* CPSR Fields */
#define ARM_MODE_SVC 0x13
#define I_BIT        0x80
#define F_BIT        0x40

/* CP15 C1 fields */
#define CP15_C1_MMU             (1 << 0)
#define CP15_C1_ALIGNMENT_FAULT (1 << 1)
#define CP15_C1_DCACHE          (1 << 2)
#define CP15_C1_SYSTEM_PROTECT  (1 << 8)
#define CP15_C1_ICACHE          (1 << 12)
#define CP15_C1_VECTORS         (1 << 13)

/* Maximum applet run time in milliseconds */
#define MAX_APPLET_RUN_TIME 5000

Q_LOGGING_CATEGORY(sambaLogConnJlink, "samba.connjlink")

static void jlink_debug_log(const char* sErr)
{
	qCDebug(sambaLogConnJlink) << QString().sprintf("%s", sErr);
}

SambaConnectionJlink::SambaConnectionJlink(QQuickItem* parent)
	: SambaConnection(parent),
	  m_swd(false),
	  m_devFamily(-1),
	  m_device(-1)
{
	JLINKARM_EnableLog(jlink_debug_log);
	JLINKARM_EnableLogCom(jlink_debug_log);
}

SambaConnectionJlink::~SambaConnectionJlink()
{
	close();
}

QStringList SambaConnectionJlink::availablePorts()
{
	QStringList list;
	JLINKARM_EMU_CONNECT_INFO connectInfo[8];
	int numDevs = JLINKARM_EMU_GetList(JLINKARM_HOSTIF_USB, connectInfo, 8);
	for (int i = 0; i < numDevs; i++)
	{
		list.append(QString().sprintf("%d", connectInfo[i].SerialNumber));
	}
	return list;
}

void SambaConnectionJlink::open()
{
	if (port().isEmpty())
	{
		QStringList ports = availablePorts();
		if (ports.isEmpty())
		{
			emit connectionFailed("No J-Link devices found");
			return;
		}

		setPort(ports.at(0));
	}

	qCInfo(sambaLogConnJlink, "Opening J-Link with S/N '%s'", port().toLocal8Bit().constData());

	bool ok = false;
	U32 serial = port().toInt(&ok);
	if (!ok)
	{
		emit connectionFailed("Port property must contain a serial number");
		return;
	}

	if (JLINKARM_EMU_SelectByUSBSN(serial))
	{
		emit connectionFailed(QString().sprintf("Could not select J-Link with serial '%u'", serial));
		return;
	}

	if (JLINKARM_Open() != NULL)
	{
		emit connectionFailed(QString().sprintf("Could not open J-Link with serial '%u'", serial));
		return;
	}

	// Set JLINK JTAG speed to 100 kHz
	JLINKARM_SetSpeed(100);

	if (m_swd)
	{
		// Select SWD interface
		if (JLINKARM_TIF_Select(JLINKARM_TIF_SWD) != 0)
		{
			emit connectionFailed("Could not select SWD interface");
			return;
		}
	}
	else
	{
		// Select JTAG interface
		if (JLINKARM_TIF_Select(JLINKARM_TIF_JTAG) != 0)
		{
			emit connectionFailed("Could not select JTAG interface");
			return;
		}
	}

	JLINKARM_Halt();
	while (!JLINKARM_IsHalted()) {}

	m_devFamily = JLINKARM_GetDeviceFamily();
	if (m_devFamily == JLINKARM_DEV_FAMILY_CORTEX_A5)
	{
		// Configure SVC Mode without IRQ & FIQ
		JLINKARM_WriteReg(ARM_REG_CPSR, F_BIT | I_BIT | ARM_MODE_SVC);

		if (!JLINKARM_CP15_IsPresent())
		{
			emit connectionFailed("CP15 not present");
			return;
		}
		else
		{
			unsigned int c0 = 0;
			unsigned int c1 = 0;

			// read ID
			JLINKARM_CP15_ReadEx(0, 0, 0, 0, &c0);

			// read Control Register
			JLINKARM_CP15_ReadEx(1, 0, 0, 0, &c1);

			// Disable MMU / Disable DCache and ICache / Vector relocation off
			c1 &= ~(CP15_C1_MMU | CP15_C1_DCACHE | CP15_C1_SYSTEM_PROTECT | CP15_C1_ICACHE | CP15_C1_VECTORS);
			JLINKARM_CP15_WriteEx(1, 0, 0, 0, c1);
		}

		// Read Devices Chip ID register
		m_device = -1;
		for (unsigned i = 0; i < ARRAY_SIZE(atmel_a5_regs); i++)
		{
			U32 udata = 0;
			JLINKARM_ReadMemU32(atmel_a5_regs[i].cidr, 1, &udata, NULL);
			if ((udata & atmel_a5_regs[i].cidr_mask) == atmel_a5_regs[i].cidr_expected)
			{
				m_device = i;
				break;
			}
		}
		if (m_device >= 0)
		{
			qCInfo(sambaLogConnJlink, "Found Atmel %s device, disabling watchdog", atmel_a5_regs[m_device].name);

			// Disable Watchdog
			JLINKARM_WriteU32(atmel_a5_regs[m_device].wdt_mr, WDT_MR_WDDIS);

			if (atmel_a5_regs[m_device].sfr_l2cc_hramc)
			{
				// Reconfigure L2-Cache as SRAM
				JLINKARM_WriteU32(atmel_a5_regs[m_device].sfr_l2cc_hramc, 0);
			}

			// Set JTAG speed
			JLINKARM_SetSpeed(3000);
		}
		else
		{
			qCInfo(sambaLogConnJlink, "Found Unknown Cortex-A5 device");

			// Set JTAG speed
			JLINKARM_SetSpeed(JLINKARM_SPEED_AUTO);
		}

		emit connectionOpened();
	}
	else
	{
		if (JLINKARM_IsOpen())
			JLINKARM_Close();

		emit connectionFailed("Unsupported device family");
	}
}

void SambaConnectionJlink::close()
{
	if (JLINKARM_IsOpen())
	{
		emit connectionClosed();
		JLINKARM_Close();
	}
}

quint8 SambaConnectionJlink::readu8(quint32 address)
{
	quint8 value;
	quint8 status;
	JLINKARM_ReadMemU8(address, 1, &value, &status);
	return value;
}

quint16 SambaConnectionJlink::readu16(quint32 address)
{
	quint16 value;
	quint8 status;
	JLINKARM_ReadMemU16(address, 1, &value, &status);
	return value;
}

quint32 SambaConnectionJlink::readu32(quint32 address)
{
	quint32 value;
	quint8 status;
	JLINKARM_ReadMemU32(address, 1, &value, &status);
	return value;
}

SambaByteArray *SambaConnectionJlink::read(quint32 address, unsigned length)
{
	QByteArray data(length, 0);
	JLINKARM_ReadMem(address, length, data.data());
	return new SambaByteArray(data);
}

bool SambaConnectionJlink::writeu8(quint32 address, quint8 data)
{
	JLINKARM_WriteU8(address, data);
	return true;
}

bool SambaConnectionJlink::writeu16(quint32 address, quint16 data)
{
	JLINKARM_WriteU16(address, data);
	return true;
}

bool SambaConnectionJlink::writeu32(quint32 address, quint32 data)
{
	JLINKARM_WriteU32(address, data);
	return true;
}

bool SambaConnectionJlink::write(quint32 address, SambaByteArray *data)
{
	JLINKARM_WriteMem(address, data->constData().length(), data->constData().constData());
	return true;
}

bool SambaConnectionJlink::go(quint32 address)
{
	QElapsedTimer timer;
	bool timeout;

	if (m_devFamily == JLINKARM_DEV_FAMILY_CORTEX_A5)
	{
		JLINKARM_Halt();
		while (!JLINKARM_IsHalted()) {}

		// set beginning address
		JLINKARM_WriteReg(ARM_REG_R14_SVC, 0);
		JLINKARM_WriteReg(ARM_REG_R15, address);
		JLINKARM_ClrBP(0);
		JLINKARM_SetBP(0, 0);

		// run
		JLINKARM_Go();

		// wait for completion
		timeout = false;
		timer.start();
		while (!JLINKARM_IsHalted())
		{
			if (timer.hasExpired(MAX_APPLET_RUN_TIME))
			{
				timeout = true;
				break;
			}

			QThread::msleep(5);
		};

		if (timeout)
			return false;

		return true;
	}

	return false;
}

quint32 SambaConnectionJlink::appletConnectionType()
{
	return JTAG;
}
