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
import SAMBA.Device.SAM9xx5 3.1

/*!
	\qmltype SAM9xx5
	\inqmlmodule SAMBA.Device.SAM9xx5
	\brief Contains chip-specific information about SAM9xx5 device.

	This QML type contains configuration, applets and tools for supporting
	the SAM9xx5 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 Low-Level Applet

	This applet is in charge of configuring the device clocks.

	The only supported command is "init".

	\section2 External RAM Applet

	This applet is in charge of configuring the external RAM.

	The Low-Level applet must have been initialized first.

	The only supported command is "init".

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAM9xx5 device (see SAM9xx5Config for
	configuration information).

	The External RAM applet must have been initialized first.

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 NAND Flash Applet

	This applet is used to flash NAND memories (see SAM9xx5Config for
	configuration information).

	The External RAM applet must have been initialized first.

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAM9xx5 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	The configuration can be set either by selecting a preset board, or by
	setting custom values. If both board and custom values are set, the board
	settings are used.

	\section2 Board selection

	A set of pre-configured values can be selected by changing the 'board'
	property. For example, the following QML snipplet selects the SAM9xx5
	EK board:

	\qml
	SAM9xx5 {
		board: "sam9xx5-ek"
	}
	\endqml

	\section2 Custom configuration

	Each configuration value can be set individually. For example, the
	following QML snipplet configures a device using MT47H64M16 DDRAM and a
	serialflash on SPI1 I/O set 1 and Chip Select 3 at 33Mhz:


	\qml
	SAM9xx5 {
		config {
			extramPreset: 1
			spiInstance: 1
			spiIoset:1 
			spiChipSelect: 3
			spiFreq: 33
		}
	}
	\endqml

*/
Device {
	name: "sam9xx5"

	aliases: [ "sam9g15", "sam9g25", "sam9g35",
	           "sam9x25", "sam9x35" ]

	description: "SAM9xx5 series"

	boards: [ "sam9xx5-ek" ]

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAM9xx5Config
	*/
	property alias config: config

	applets: [
		SAM9xx5LowlevelApplet { },
		SAM9xx5ExtRamApplet { },
		SAM9xx5SerialFlashApplet { },
		SAM9xx5NANDFlashApplet { }
	]

	/*!
		\brief Initialize the SAM9xx5 device using the given \a connection.

		This method calls checkDeviceID.
	*/
	function initialize(connection) {
		checkDeviceID(connection)
	}

	/*!
		\brief Checks that the device is a SAM9xx5.

		Reads CHIPID_CIDR register using the given \a connection and display
		a warning if its value does not match the expected value for SAM9xx5.
	*/
	function checkDeviceID(connection) {
		// read CHIPID_CIDR & CHIPID_EXID registers
		var cidr = connection.readu32(0xfffff240)
		var exid = connection.readu32(0xfffff244)
		var sam9xx5 = false
		if (cidr === 0x819a05a1) {
			sam9xx5 = true
			switch (exid) {
				case 0:
					print("Compatible device detected: SAM9G15.")
					break
				case 1:
					print("Compatible device detected: SAM9G35.")
					break
				case 2:
					print("Compatible device detected: SAM9X35.")
					break
				case 3:
					print("Compatible device detected: SAM9G25.")
					break
				case 4:
					print("Compatible device detected: SAM9X25.")
					break
				default:
					sam9xx5 = false
					break
			}
		}
		if (!sam9xx5)
			print("Warning: Invalid CIDR/EXID (" +
			      Utils.hex(cidr) + "/" + Utils.hex(exid) +
			      ", no known SAM9xx5 chip detected!")
	}

	onBoardChanged: {
		if (board === "" || typeof board === "undefined") {
			config.extramPreset = undefined
			config.spiInstance = undefined
			config.spiIoset = undefined
			config.spiChipSelect = undefined
			config.spiFreq = undefined
			config.nandIoset = undefined
			config.nandBusWidth = undefined
			config.nandHeader = undefined
		}
		else if (board === "sam9xx5-ek") {
			config.extramPreset = 1 /* MT47H64M16 */
			config.spiInstance = 0
			config.spiIoset = 1
			config.spiChipSelect = 0
			config.spiFreq = 66
			config.nandIoset = 1
			config.nandBusWidth = 16
			config.nandHeader = 0xc0082405
		}
		else {
			var invalidBoard = board
			board = undefined
			throw new Error("Unknown SAM9xx5 board '" + invalidBoard + "'")
		}
	}

	SAM9xx5Config {
		id: config
	}
}
