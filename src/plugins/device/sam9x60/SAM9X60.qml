/*
 * Copyright (c) 2018, Microchip.
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
import SAMBA.Device.SAM9X60 3.2

/*!
	\qmltype SAM9X60
	\inqmlmodule SAMBA.Device.SAM9X60
	\brief Contains chip-specific information about SAM9X60 device.

	This QML type contains configuration, applets and tools for supporting
	the SAM9X60 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".
*/
Device {
	family: "sam9x60"

	name: "sam9x60"

	aliases: [ ]

	description: "SAM9X60 series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAM9X60Config
	*/
	property alias config: config

	applets: [
		SAM9X60BootConfigApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-bootconfig_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SAM9X60LowlevelApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		ExtRamApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-extram_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sam9x60-generic_ddram.bin")
			codeAddr: 0x20000000
			mailboxAddr: 0x20000004
			entryAddr: 0x20000000
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sam9x60-generic_ddram.bin")
			codeAddr: 0x20000000
			mailboxAddr: 0x20000004
			entryAddr: 0x20000000
		},
		QSPIFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sam9x60-generic_ddram.bin")
			codeAddr: 0x20000000
			mailboxAddr: 0x20000004
			entryAddr: 0x20000000
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sam9x60-generic_ddram.bin")
			codeAddr: 0x20000000
			mailboxAddr: 0x20000004
			entryAddr: 0x20000000
			nandHeaderHelp: "For information on NAND header values, please refer to SAM9X60 datasheet section \"10.4.4 Detailed Memory Boot Procedures\"."
		},
		ResetApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-reset_sam9x60-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			entryAddr: 0x300000
		}
	]

	/*!
		\brief Initialize the SAM9X60 device using the current connection.

		This method calls checkDeviceID.
	*/
	function initialize() {
	}

	SAM9X60Config {
		id: config
	}
}
