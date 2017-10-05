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

import QtQuick 2.3
import SAMBA 3.2
import SAMBA.Applet 3.2
import SAMBA.Device.SAMA5D2 3.2

/*!
	\qmltype SAMA5D2
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains chip-specific information about SAMA5D2 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D2 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 Low-Level Applet

	This applet is in charge of configuring the device clocks.

	It is only needed when using JTAG for communication with the device.
	When communication using USB or Serial via the SAM-BA Monitor, the clocks are
	already configured by the ROM-code.

	The only supported command is "init".

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".

	Note: The external RAM is not needed for correct operation of the other
	applets. It is only provided as a way to upload and run user programs
	from external RAM.

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D2 device (see SAMA5D2Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 QuadSPI Flash Applet

	This applet is used to flash QuadSPI memories. It supports both QSPI
	controllers present on the SAMA5D2 (see SAMA5D2Config for configuration
	information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 NAND Applet

	This applet is used to flash NAND memories (see SAMA5D2Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 SDMMC Applet

	This applet is used to read/write SD/MMC and e.MMC devices. It supports
	all SDMMC peripherals present on the SAMA5D2 device (see SAMA5D2Config
	for configuration information).

	Supported commands are "init", "read" and "write".

	\section1 Configuration

	When creating an instance of the SAMA5D2 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	\section2 Preset Board selection

	A set of pre-configured values can be selected by instanciating
	sub-classes of SAMA5D2.  The following preset boards are available:

	\table
	\header \li Command-Line Name \li QML Name        \li Board Name
	\row    \li sama5d2-xplained  \li SAMA5D2Xplained \li SAMA5D2 Xplained Ultra
	\endtable

	\section2 Custom configuration

	Each configuration value can be set individually.  Please see
	SAMA5D2Config for details on the configuration values.

	For example, the following QML snipplet configures a device using SPI1
	on I/O set 2 and Chip Select 3 at 33Mhz:

	\qml
	SAMA5D2 {
		config {
			serialflash {
				instance: 1
				ioset: 2
				chipSelect: 3
				freq: 33
			}
		}
	}
	\endqml
*/
Device {
	family: "sama5d2"

	name: "sama5d2"

	aliases: [ "sama5d21", "sama5d22", "sama5d23", "sama5d24",
	           "sama5d26", "sama5d27", "sama5d28" ]

	description: "SAMA5D2x series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA5D2Config
	*/
	property alias config: config

	applets: [
		SAMA5D2BootConfigApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		},
		LowlevelApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		},
		ExtRamApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-extram_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		},
		QSPIFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
			nandHeaderHelp: "For information on NAND header values, please refer to SAMA5D2 datasheet section \"15.4.6 Detailed Memory Boot Procedures\"."
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama5d2-generic_sram.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			entryAddr: 0x220000
		}
	]

	/*!
		\brief Initialize the SAMA5D2 device using the current connection.

		This method calls checkDeviceID and then reconfigures the
		L2-Cache as SRAM for use by the applets.
	*/
	function initialize() {
		checkDeviceID()

		// Reconfigure L2-Cache as SRAM
		var SFR_L2CC_HRAMC = 0xf8030058
		connection.writeu32(SFR_L2CC_HRAMC, 0)
	}

	/*!
		\brief Checks that the device is a SAMA5D2.

		Reads CHIPID_CIDR register using the current connection and display
		a warning if its value does not match the expected value for SAMA5D2.
	*/
	function checkDeviceID() {
		// read CHIPID_CIDR register
		var cidr = connection.readu32(0xfc069000)
		// Compare cidr using mask to skip revision field.
		if (((cidr & 0xffffffe0) >>> 0) !== 0x8a5c08c0)
			print("Warning: Invalid CIDR, no known SAMA5D2 chip detected!")
	}

	SAMA5D2Config {
		id: config
	}
}
