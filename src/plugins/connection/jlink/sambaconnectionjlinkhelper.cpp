/*
 * Copyright (c) 2015-2016, Atmel Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

#include "sambaconnectionjlinkhelper.h"
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

/* Maximum time to wait for initial target halting (in milliseconds) */
#define INITIAL_HALT_TIMEOUT 1000

Q_LOGGING_CATEGORY(sambaLogConnJlink, "samba.connjlink")

static void jlink_debug_log(const char* sErr)
{
	qCDebug(sambaLogConnJlink) << QString().sprintf("%s", sErr);
}

SambaConnectionJlinkHelper::SambaConnectionJlinkHelper(QQuickItem* parent)
	: QQuickItem(parent),
	  m_swd(false),
	  m_devFamily(-1),
	  m_device(-1)
{
	JLINKARM_EnableLog(jlink_debug_log);
	JLINKARM_EnableLogCom(jlink_debug_log);
}

SambaConnectionJlinkHelper::~SambaConnectionJlinkHelper()
{
	close();
}

QString SambaConnectionJlinkHelper::serialNumber() const
{
	return m_serialNumber;
}

void SambaConnectionJlinkHelper::setSerialNumber(const QString& serialNumber)
{
	if (m_serialNumber != serialNumber)
	{
		m_serialNumber = serialNumber;
		emit serialNumberChanged();
	}
}

bool SambaConnectionJlinkHelper::swd() const
{
	return m_swd;
}

void SambaConnectionJlinkHelper::setSwd(bool swd)
{
	if (m_swd != swd)
	{
		m_swd = swd;
		emit swdChanged();
	}
}

QStringList SambaConnectionJlinkHelper::availableSerialNumbers()
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

void SambaConnectionJlinkHelper::open()
{
	if (serialNumber().isEmpty())
	{
		QStringList serialNumbers = availableSerialNumbers();
		if (serialNumbers.isEmpty())
		{
			emit connectionFailed("No J-Link devices found");
			return;
		}

		setSerialNumber(serialNumbers.at(0));
	}

	qCInfo(sambaLogConnJlink, "Opening J-Link with S/N '%s'", serialNumber().toLocal8Bit().constData());

	bool ok = false;
	U32 serial = serialNumber().toInt(&ok);
	if (!ok)
	{
		emit connectionFailed("Could not parse serial number");
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
		}
		else
		{
			qCInfo(sambaLogConnJlink, "Found Unknown Cortex-A5 device");
		}

		JLINKARM_SetSpeed(JLINKARM_SPEED_AUTO);

		QElapsedTimer timer;
		timer.start();
		JLINKARM_Halt();
		while (!JLINKARM_IsHalted()) {
			if (timer.hasExpired(INITIAL_HALT_TIMEOUT)) {
				emit connectionFailed("Timeout while waiting for device to be halted");
				return;
			}
			QThread::msleep(5);
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

void SambaConnectionJlinkHelper::close()
{
	if (JLINKARM_IsOpen())
	{
		emit connectionClosed();
		JLINKARM_Close();
	}
}

QVariant SambaConnectionJlinkHelper::readu8(quint32 address)
{
	if (JLINKARM_IsHalted()) {
		quint8 value;
		quint8 status;
		JLINKARM_ReadMemU8(address, 1, &value, &status);
		return QVariant(value);
	} else {
		return QVariant();
	}
}

QVariant SambaConnectionJlinkHelper::readu16(quint32 address)
{
	if (JLINKARM_IsHalted()) {
		quint16 value;
		quint8 status;
		JLINKARM_ReadMemU16(address, 1, &value, &status);
		return QVariant(value);
	} else {
		return QVariant();
	}
}

QVariant SambaConnectionJlinkHelper::readu32(quint32 address)
{
	if (JLINKARM_IsHalted()) {
		quint32 value;
		quint8 status;
		JLINKARM_ReadMemU32(address, 1, &value, &status);
		return QVariant(value);
	} else {
		return QVariant();
	}
}

SambaByteArray *SambaConnectionJlinkHelper::read(quint32 address, unsigned length)
{
	if (JLINKARM_IsHalted()) {
		QByteArray data(length, 0);
		JLINKARM_ReadMem(address, length, data.data());
		return new SambaByteArray(data);
	} else {
		return 0;
	}
}

bool SambaConnectionJlinkHelper::writeu8(quint32 address, quint8 data)
{
	if (JLINKARM_IsHalted()) {
		JLINKARM_WriteU8(address, data);
		return true;
	} else {
		return false;
	}
}

bool SambaConnectionJlinkHelper::writeu16(quint32 address, quint16 data)
{
	if (JLINKARM_IsHalted()) {
		JLINKARM_WriteU16(address, data);
		return true;
	} else {
		return false;
	}
}

bool SambaConnectionJlinkHelper::writeu32(quint32 address, quint32 data)
{
	if (JLINKARM_IsHalted()) {
		JLINKARM_WriteU32(address, data);
		return true;
	} else {
		return false;
	}
}

bool SambaConnectionJlinkHelper::write(quint32 address, SambaByteArray *data)
{
	if (JLINKARM_IsHalted()) {
		JLINKARM_WriteMem(address, data->constData().length(), data->constData().constData());
		return true;
	} else {
		return false;
	}
}

bool SambaConnectionJlinkHelper::go(quint32 address)
{
	if (m_devFamily == JLINKARM_DEV_FAMILY_CORTEX_A5)
	{
		if (!JLINKARM_IsHalted())
			return false;

		// set beginning address
		JLINKARM_WriteReg(ARM_REG_R14_SVC, 0);
		JLINKARM_WriteReg(ARM_REG_R15, address);
		JLINKARM_ClrBP(0);
		JLINKARM_SetBP(0, 0);

		// run
		JLINKARM_Go();
		return true;
	}

	return false;
}
