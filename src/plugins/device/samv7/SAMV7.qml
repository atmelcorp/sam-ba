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

import SAMBA 3.1

/*!
	\qmltype SAMV7
	\inqmlmodule SAMBA.Device.SAMV7
	\brief Contains chip-specific information about SAMV7 devices.
*/
Device {
	name: "samv7"

	aliases: ["samv70", "samv71", "same70", "sams70" ]

	description: "SAMV70, SAMV71, SAME70, SAMS70"

	applets: [
		Applet {
			name: "lowlevel"
			description: "Low-Level"
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevelinit-samv7.bin")
			codeAddr: 0x20401000
			mailboxAddr: 0x20401040
			commands: [
				AppletCommand { name:"legacyInitialize"; code:0 }
			]
		},
		Applet {
			name: "flash"
			description: "Internal Flash"
			codeUrl: Qt.resolvedUrl("applets/applet-flash-samv7.bin")
			codeAddr: 0x20401000
			mailboxAddr: 0x20401040
			pageSize: 512
			eraseSupport: 256 /* 256 pages: 128K */
			commands: [
				AppletCommand { name:"legacyInitialize"; code:0 },
				AppletCommand { name:"legacyEraseAll"; code:1; timeout:25000 },
				AppletCommand { name:"legacyWriteBuffer"; code:2 },
				AppletCommand { name:"legacyReadBuffer"; code:3 },
				AppletCommand { name:"legacyGpnvm"; code:6 }
			]
		}
	]

	/*!
		\brief Initialize the SAMV7 device using the given \a connection.

		This method calls checkDeviceID.
	*/
	function initialize(connection) {
		checkDeviceID(connection)
	}

	/*!
		\brief Checks that the device is a SAMx7.

		Reads CHIPID_CIDR register using the given \a connection and display
		a warning if its value does not match the expected value for SAMx7.
	*/
	function checkDeviceID(connection) {
		// read ARCH field of CHIPID_CIDR register
		var arch = (connection.readu32(0x400e0940) >> 20) & 0xff
		if (arch < 0x10 || arch > 0x13)
			print("Warning: Invalid CIDR, no known SAMx7 chip detected!")
	}

	onBoardChanged: {
		if (board !== "" && typeof board !== "undefined") {
			board = undefined
			throw new Error("SAMV7 device has no board support.")
		}
	}
}
