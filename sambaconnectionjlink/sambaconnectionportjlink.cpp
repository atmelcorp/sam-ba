#include "sambaconnectionportjlink.h"
#include "sambalogger.h"
#include <QDebug>
#include <QThread>
#include <QElapsedTimer>
#include <JLinkARMDLL.h>

#define ARRAY_SIZE(x) (sizeof(x)/sizeof(*(x)))

struct atmel_a5_regs {
	const char *name;
	unsigned int dbgu_cidr;
	unsigned int dbgu_cidr_mask;
	unsigned int dbgu_cidr_expected;
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

SambaConnectionPortJlink::SambaConnectionPortJlink(QObject* parent, U32 serialNumber)
	: SambaConnectionPort(parent),
	  m_serialNumber(serialNumber),
	  m_devFamily(-1),
	  m_device(-1),
	  m_useSWD(false)
{
	m_tag = QString().sprintf("jlink:%u", m_serialNumber);
	m_name = QString().sprintf("J-Link (%u)", m_serialNumber);
	m_description = m_name;
}

SambaConnectionPortJlink::~SambaConnectionPortJlink()
{
	disconnect();
}

static void jlink_debug_log(const QString& text)
{
	SambaLogger::getInstance()->append(QString("JLINK"), text);
}

static void jlink_debug_log(const char* sErr)
{
	jlink_debug_log(QString().sprintf("%s", sErr));
}

bool SambaConnectionPortJlink::useSWD()
{
	return m_useSWD;
}

void SambaConnectionPortJlink::setUseSWD(bool useSWD)
{
	m_useSWD = useSWD;
}

bool SambaConnectionPortJlink::connect()
{
	qDebug("Connecting to %s", description().toLatin1().constData());

	JLINKARM_EnableLog(jlink_debug_log);
	JLINKARM_EnableLogCom(jlink_debug_log);

	if (JLINKARM_EMU_SelectByUSBSN(m_serialNumber))
	{
		jlink_debug_log(QString().sprintf("Error while selecting J-Link with serial '%u'", m_serialNumber));
		return false;
	}

	if (JLINKARM_Open() != NULL)
	{
		jlink_debug_log(QString().sprintf("Error while opening J-Link with serial '%u'", m_serialNumber));
		return false;
	}

	// Set JLINK JTAG speed to 100 kHz
	JLINKARM_SetSpeed(100);

	if (m_useSWD)
	{
		// Select SWD interface
		if (JLINKARM_TIF_Select(JLINKARM_TIF_SWD) != 0)
		{
			jlink_debug_log(QString().sprintf("Error while enabling SWD mode"));
			return false;
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
			// TODO log error
			disconnect();
			return false;
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
			JLINKARM_ReadMemU32(atmel_a5_regs[i].dbgu_cidr, 1, &udata, NULL);
			if ((udata & atmel_a5_regs[i].dbgu_cidr_mask) == atmel_a5_regs[i].dbgu_cidr_expected)
			{
				m_device = i;
				break;
			}
		}
		if (m_device >= 0)
		{
			jlink_debug_log(QString().sprintf("Found Atmel %s device, disabling watchdog", atmel_a5_regs[m_device].name));

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
			jlink_debug_log("Found Unknown Cortex-A5 device");

			// Set JTAG speed
			JLINKARM_SetSpeed(JLINKARM_SPEED_AUTO);
		}

		return true;
	}
	else
	{
		disconnect();
		return false;
	}
}

void SambaConnectionPortJlink::disconnect()
{
	if (JLINKARM_IsOpen())
		JLINKARM_Close();
}

quint8 SambaConnectionPortJlink::readu8(quint32 address)
{
	quint8 value;
	quint8 status;
	JLINKARM_ReadMemU8(address, 1, &value, &status);
	return value;
}

quint16 SambaConnectionPortJlink::readu16(quint32 address)
{
	quint16 value;
	quint8 status;
	JLINKARM_ReadMemU16(address, 1, &value, &status);
	return value;
}

quint32 SambaConnectionPortJlink::readu32(quint32 address)
{
	quint32 value;
	quint8 status;
	JLINKARM_ReadMemU32(address, 1, &value, &status);
	return value;
}

QByteArray SambaConnectionPortJlink::read(quint32 address, int length)
{
	QByteArray result(length, 0);
	JLINKARM_ReadMem(address, length, result.data());
	return result;
}

bool SambaConnectionPortJlink::writeu8(quint32 address, quint8 data)
{
	JLINKARM_WriteU8(address, data);
	return true;
}

bool SambaConnectionPortJlink::writeu16(quint32 address, quint16 data)
{
	JLINKARM_WriteU16(address, data);
	return true;
}

bool SambaConnectionPortJlink::writeu32(quint32 address, quint32 data)
{
	JLINKARM_WriteU32(address, data);
	return true;
}

bool SambaConnectionPortJlink::write(quint32 address, const QByteArray &data)
{
	JLINKARM_WriteMem(address, data.length(), data.constData());
	return true;
}

bool SambaConnectionPortJlink::go(quint32 address)
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

quint32 SambaConnectionPortJlink::appletCommType()
{
	return SambaApplet::CommJTAG;
}
