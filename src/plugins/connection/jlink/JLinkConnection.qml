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
import SAMBA.Connection.JLink 3.2

/*!
\qmltype JLinkConnection
\inherits Connection
\inqmlmodule SAMBA.Connection.JLink
\brief JLinkConnection represents a JTAG connection to a programmable device
using SEGGER J-Link adapter.

JLinkConnection can be used to connect to a device using SEGGER J-Link Adapter.

The device must have its JTAG port enabled. For example the SAMA5D4 device
needs to recieve a command on the SAM-BA Monitor in order to enable its JTAG
port. Please see the datasheet/manual of the device for more information.
*/
Connection {
	name: "j-link"
	aliases: [ "jlink", "samice", "sam-ice" ]
	priority: 2

	/*!
	\qmlproperty string JLinkConnection::serialNumber
	\brief The serialNumber to use for the connection.

	This property contains the serial number of the SEGGER J-Link Adapter to use
	for the connection, for example "12345678".
	*/
	property alias serialNumber: helper.serialNumber

	/*!
	\qmlproperty bool JLinkConnection::swd
	\brief Whether the connection should be done using SWD mode or JTAG mode.
	*/
	property alias swd: helper.swd

	/*!
	\sa Connection::open()
	*/
	function open() {
		helper.open()
	}

	/*!
	\sa Connection::close()
	*/
	function close() {
		helper.close()
	}

	/*!
	\sa Connection::readu8()
	*/
	function readu8(address, timeout) {
		return helper.readu8(address)
	}

	/*!
	\sa Connection::readu16()
	*/
	function readu16(address, timeout) {
		return helper.readu16(address)
	}

	/*!
	\sa Connection::readu32()
	*/
	function readu32(address, timeout) {
		return helper.readu32(address)
	}

	/*!
	\sa Connection::read()
	*/
	function read(address, length, timeout) {
		return helper.read(address, length)
	}

	/*!
	\sa Connection::writeu8()
	*/
	function writeu8(address, data) {
		return helper.writeu8(address, data)
	}

	/*!
	\sa Connection::writeu16()
	*/
	function writeu16(address, data) {
		return helper.writeu16(address, data)
	}

	/*!
	\sa Connection::writeu32()
	*/
	function writeu32(address, data) {
		return helper.writeu32(address, data)
	}

	/*!
	\sa Connection::write()
	*/
	function write(address, data) {
		return helper.write(address, data)
	}

	/*!
	\sa Connection::go()
	*/
	function go(address) {
		return helper.go(address)
	}

	/*!
	\sa Connection::waitForMonitor()
	*/
	function waitForMonitor(timeout) {
		return helper.waitForMonitor(timeout)
	}

	/*! \internal */
	function handle_helper_connectionOpened(at91) {
		print("Connection opened.")
		appletConnectionType = AppletConnectionType.JTAG
		if (autoDeviceInit && (typeof device !== "undefined"))
			device.initialize()
		connectionOpened()
	}

	/*! \internal */
	function handle_helper_connectionFailed(message) {
		print("Error: " + message)
		connectionFailed(message)
	}

	/*! \internal */
	function handle_helper_connectionClosed() {
		print("Connection closed.")
		connectionClosed()
	}

	JLinkConnectionHelper {
		id: helper
		onConnectionOpened: parent.handle_helper_connectionOpened()
		onConnectionFailed: parent.handle_helper_connectionFailed(message)
		onConnectionClosed: parent.handle_helper_connectionClosed()
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		switch (args.length) {
		case 2:
			if (args[1].length > 0) {
				var proto = args[1].toLowerCase();
				if (proto === "swd")
					swd = true
				else if (proto === "jtag")
					swd = false
				else
					return "Invalid protocol argument (should be 'swd' or 'jtag')"
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				port = args[0];
			}
			// fall-through
		case 0:
			return
		default:
			return "Invalid number of arguments"
		}
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax:",
		        "    j-link:[<S/N>]:[swd|jtag]",
		        "Examples:",
		        "    j-link             use first J-Link device found",
		        "    j-link:123456      use J-Link with serial number 123456",
		        "    j-link:123456:swd  use J-Link with serial number 123456, in SWD mode",
		        "    j-link::swd        use first J-Link device found, in SWD mode",
		        "    j-link::jtag       use first J-Link device found, in JTAG mode (JTAG mode is the default)"]
	}
}
