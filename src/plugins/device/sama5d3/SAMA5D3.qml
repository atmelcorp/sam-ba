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

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D3 device (see SAMA5D3Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAMA5D3 type, some configuration can
	be supplied. The configuration parameters are then used during applet
	initialization where relevant.

	The configuration can be set either by selecting a preset board, or by
	setting custom values. If both board and custom values are set, the board
	settings are used.

	\section2 Board selection

	A set of pre-configured values can be selected by changing the 'board'
	property. For example, the following QML snipplet selects the SAMA5D3
	Xplained board:

	\qml
	SAMA5D3 {
		board: "sama5d3-xplained"
	}
	\endqml

	\section2 Custom configuration

	Each configuration value can be set individually. For example, the
	following QML snipplet configures a device using SPI1 on I/O set 1 and
	Chip Select 3 at 33Mhz:

	\qml
	SAMA5D3 {
		config {
			spiInstance: 1
			spiIoset: 1
			spiChipSelect: 3
			spiFreq: 33
		}
	}
	\endqml

*/
Device {
	name: "sama5d3"

	aliases: [ "sama5d31", "sama5d33", "sama5d34", "sama5d35", "sama5d36" ]

	description: "SAMA5D3x series"

	boards: [ "sama5d3-xplained" ]

	/*!
		\brief The device configuration used by applets (peripherals, I/O sets, etc.)
		\sa SAMA5D3Config
	*/
	property alias config: config

	applets: [
		SAMA5D3LowlevelApplet { },
		SAMA5D3SerialFlashApplet { },
		SAMA5D3NANDFlashApplet { }
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

	onBoardChanged: {
		if (board === "" || typeof board === "undefined") {
			config.spiInstance = undefined
			config.spiIoset = undefined
			config.spiChipSelect = undefined
			config.spiFreq = undefined
			config.nandIoset = undefined
			config.nandBusWidth = undefined
			config.nandHeader = undefined
		}
		else if (board === "sama5d3-xplained") {
			config.spiInstance = 0
			config.spiIoset = 1
			config.spiChipSelect = 0
			config.spiFreq = 48
			config.nandIoset = 1
			config.nandBusWidth = 8
			config.nandHeader = 0xc0902405
		}
		else {
			var invalidBoard = board
			board = undefined
			throw new Error("Unknown SAMA5D3 board '" + invalidBoard + "'")
		}
	}

	SAMA5D3Config {
		id: config
	}
}
