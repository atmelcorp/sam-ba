/*
 * Copyright (c) 2016, Atmel Corporation.
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
import SAMBA 3.1
import SAMBA.Applet 3.1
import SAMBA.Device.SAMA5D3 3.1

/*!
	\qmltype SAMA5D3
	\inqmlmodule SAMBA.Device.SAMA5D3
	\brief Contains chip-specific information about SAMA5D3 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D3 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 SDMMC Applet

	This applet is used to read/write SD/MMC and e.MMC devices. It supports
	all HSMCI peripherals present on the SAMA5D3 device (see SAMA5D3Config
	for configuration information).

	Supported commands are "init", "read" and "write".

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D3 device (see SAMA5D3Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 NAND Applet

	This applet is used to flash NAND memories (see SAMA5D2Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAMA5D3 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	\section2 Board selection

	A set of pre-configured values can be selected by instanciating
	sub-classes of SAMA5D3.  The following preset boards are available:

	\table
	\header \li Command-Line Name \li QML Name        \li Board Name
	\row    \li sama5d3-ek        \li SAMA5D3EK       \li SAMA5D3x-MB
	\row    \li sama5d3-xplained  \li SAMA5D3Xplained \li SAMA5D3 Xplained
	\endtable

	\section2 Custom configuration

	Each configuration value can be set individually.  Please see
	SAMA5D3Config for details on the configuration values.

	For example, the following QML snipplet configures a device using SPI1
	on I/O set 2 and Chip Select 3 at 33Mhz:

	\qml
	SAMA5D3 {
		config {
			serialflash {
				instance: 1
				ioset: 1
				chipSelect: 3
				freq: 33
			}
		}
	}
	\endqml
*/
Device {
	name: "sama5d3"

	aliases: [ "sama5d31", "sama5d33", "sama5d34", "sama5d35", "sama5d36" ]

	description: "SAMA5D3x series"

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA5D3Config
	*/
	property alias config: config

	applets: [
		LowlevelApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
		},
		SDMMCApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-sdmmc_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
		},
		SerialFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
		},
		NANDFlashApplet {
			codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sama5d3-generic_sram.bin")
			codeAddr: 0x300000
			mailboxAddr: 0x300004
			nandHeaderHelp: "For information on NAND header values, please refer to SAMA5D3 datasheet section \"11.4.4 Detailed Memory Boot Procedures\"."
		}
	]

	/*!
		\brief Initialize the SAMA5D3 device using the given \a connection.

		This method calls checkDeviceID.
	*/
	function initialize(connection) {
		checkDeviceID(connection)
	}

	/*!
		\brief Checks that the device is a SAMA5D3.

		Reads CHIPID_CIDR register using the given \a connection and display
		a warning if its value does not match the expected value for SAMA5D3.
	*/
	function checkDeviceID(connection) {
		// read CHIPID_CIDR register
		var cidr = connection.readu32(0xffffee40)
		// Compare cidr using mask to skip revision field.
		if (cidr !== 0x8a5c07c2)
			print("Warning: Invalid CIDR, no known SAMA5D3 chip detected!")
		// read CHIPID_EXID register
		var exid = connection.readu32(0xffffee44)
		switch (exid) {
			case 0x00444300:
			case 0x00414300:
			case 0x00414301:
			case 0x00584300:
			case 0x00004301:
				break;
			default:
				print("Warning: Invalid EXID, no known SAMA5D3 chip detected!")
				break;
		}
	}

	SAMA5D3Config {
		id: config
	}
}
