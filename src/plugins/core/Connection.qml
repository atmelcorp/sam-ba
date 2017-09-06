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

/*!
	\qmltype Connection
	\inqmlmodule SAMBA
	\brief The Connection type represents a physical connection to a programmable device.

	This type contains methods to communicate with a device:
	\list
	\li reading/writing memory
	\li requesting execution of code
	\li basic functions to load and execute applets
	\endlist

	It is only intended to define the method prototypes and does not communicate with anything.
	Please use any of the types that inherit from \l{SAMBA::}{Connection} for actual usable implementations.

	\section2 Reading and Writing Memory

	The following methods are provided to read and write to memory:

	\table
	\header
	\li Name
	\li Description
	\row
	\li \l{Connection::}{read}
	\li Reads a memory block
	\row
	\li \l{Connection::}{readu8}
	\li Reads single unsigned byte
	\row
	\li \l{Connection::}{readu16}
	\li Reads single unsigned 16-bit word
	\row
	\li \l{Connection::}{readu32}
	\li Reads single unsigned 32-bit word
	\row
	\li \l{Connection::}{write}
	\li Writes a memory block
	\row
	\li \l{Connection::}{writeu8}
	\li Writes single unsigned byte
	\row
	\li \l{Connection::}{writeu16}
	\li Writes single unsigned 16-bit word
	\row
	\li \l{Connection::}{writeu32}
	\li Writes single unsigned 32-bit word
	\endtable

	For example, to read a 32-bit unsigned word at address 0x12345678:
	\code
	var data = connection.readu32(0x12345678)
	\endcode

	To write unsigned 32-bit value 0x42 to address 0x12345678:
	\code
	connection.writeu32(0x12345678, 0x42)
	\endcode

	\section2 Executing Code

	The \tt go method can be used to execute code on the device. It make the CPU jump to the given address.
	Please note that depending on the communication method, the executed code may have to give the control back to its caller.
	SAM-BA \l{SAMBA::Applet}{Applets} contain such code to give back control to SAM-BA Monitor.

	For example, to execute code at address 0x12345678:
	\code
	connection.go(0x12345678)
	\endcode

	\section2 Loading and Running Applets

	The Connection type also contains methods to load and execute applets (see \l{SAMBA::Applet}{Applet} for more information on SAM-BA applets).
	The methods related to applet handling are:
	\table
	\header \li Name \li Description
	\row \li appletUpload \li Upload the applet code to the device
	\row \li appletMailboxRead \li Reads single unsigned 32-bit word from the mailbox
	\row \li appletBufferRead \li Reads a block from the applet buffer
	\row \li appletBufferWrite \li Writes a block into the applet buffer
	\row \li appletExecute \li Writes parameters in the applet mailbox and execute the applet code
	\endtable

	For example, to load and initialize an applet:
	\code
	connection.appletUpload(applet)
	connection.appletExecute("init")
	\endcode
	This example assumes that:
	\list
	\li the applet initialization command is named "init"
	\li it takes no arguments
	\endlist

	To read a 0x42 bytes block at offset 0x1234 from a "memory" applet:
	\code
	connection.appletExecute("read", [ connection.applet.bufferAddr, 0x42, 0x1234 ])
	var block = connection.appletBufferRead(0x42)
	\endcode
	This example assumes that:
	\list
	\li the applet has already been loaded/intialized
	\li its read command is named "read" and that it takes as arguments the buffer address, the number of bytes to read and the starting address
	\endlist
*/
Item {
	/*!
		\qmlproperty string Connection::name
		\brief The connection name
	*/
	property var name

	/*!
		\qmlproperty list<string> Connection::aliases
		\brief The connection aliases (alternate names that can be used
		on the command-line)
	*/
	property var aliases

	/*!
		\qmlproperty int Connection::priority
		\brief The connection priority value

		The connection with the lowest priority is selected by default
		when no connection parameter is provided on the command-line.
	*/
	property var priority

	/*!
		\qmlproperty bool Connection::autoConnect
		\brief Connection automatic connection flag

		Whether the connection should be automatically established once
		the Connection QML object is ready.
	*/
	property bool autoConnect: true

	/*!
		\qmlproperty int Connection::appletConnectionType
		\brief The connection type value passed at applet initialization
	*/
	property var appletConnectionType

	/*!
		\qmlproperty Device Connection::device
		\brief Device whose applets will be used
	*/
	property var device

	/*!
		\qmlproperty bool Connection::autoDeviceInit
		\brief Connection automatic device initialization flag

		Whether the device initialize() function should be automatically called once
		the connection is opened.
	*/
	property bool autoDeviceInit: true

	/*!
		\qmlproperty Applet Connection::applet
		\brief The current applet, or \tt undefined if no applet is loaded.
	*/
	property var applet

	/*!
		\qmlsignal Connection::connectionOpened()
		\brief This signal is triggered when the connection has been opened successfully.
	*/
	signal connectionOpened();

	/*!
		\qmlsignal Connection::connectionFailed(string message)
		\brief This signal is triggered when the connection failed to open.

		The \a message parameter contains the failure cause.
	*/
	signal connectionFailed(string message);

	/*!
		\qmlsignal Connection::connectionClosed()
		\brief This signal is triggered when the connection has been closed.
	*/
	signal connectionClosed();

	/*!
		\qmlmethod void Connection::open()
		\brief Opens the connection.

		On success, the connectionOpened signal will be raised.  If an
		error occurrs, the connectionFailed signal will be raised with
		the failure cause as argument.
	*/
	function open() {
		connectionFailed("open() not implemented on base Connection object.")
	}

	/*!
		\qmlmethod void Connection::close()
		\brief Closes the connection.

		The connectionClosed signal will be raised when the connection
		is closed.
	*/
	function close() {
		// do nothing
	}

	/*!
		\qmlmethod int Connection::readu8(int address, int timeout)
		\brief Read a single unsigned byte at the given \a address.

		Returns the unsigned byte read at \a address or undefined if an
		error occured or if no value could be read after \a timeout
		milliseconds.
	*/
	function readu8(address, timeout) {
		return
	}

	/*!
		\qmlmethod int Connection::readu16(int address, int timeout)
		\brief Read a single unsigned 16-bit word at the given \a address.

		Returns the unsigned 16-bit word read at \a address or
		undefined if an error occured or if no value could be read
		after \a timeout milliseconds.
	*/
	function readu16(address, timeout) {
		return
	}

	/*!
		\qmlmethod int Connection::readu32(int address, int timeout)
		\brief Read a single unsigned 32-bit word at the given \a address.

		Returns the unsigned 32-bit word read at \a address or
		undefined if an error occured or if no value could be read
		after \a timeout milliseconds.
	*/
	function readu32(address, timeout) {
		return
	}

	/*!
		\qmlmethod ByteArray Connection::read(int address, int length)
		\brief Read \a length bytes at address \a address.

		Returns a ByteArray with the data or undefined if an error
		occured or if no data could be read after \a timeout
		milliseconds.
	*/
	function read(address, length, timeout) {
		return
	}

	/*!
		\qmlmethod bool Connection::writeu8(int address, int data)
		\brief Write unsigned byte \a data at address \a address.

		Returns true on success, false otherwise.
	*/
	function writeu8(address, data, timeout) {
		return false
	}

	/*!
		\qmlmethod bool Connection::writeu16(int address, int data)
		\brief Write unsigned 16-bit word \a data at address \a address.

		Returns true on success, false otherwise.
	*/
	function writeu16(address, data) {
		return false
	}

	/*!
		\qmlmethod bool Connection::writeu32(int address, int data)
		\brief Write unsigned 32-bit word \a data at address \a address.

		Returns true on success, false otherwise.
	*/
	function writeu32(address, data) {
		return false
	}

	/*!
		\qmlmethod bool Connection::write(int address, ByteArray data)
		\brief Write byte array \a data at address \a address.

		Returns true on success, false otherwise.
	*/
	function write(address, data) {
		return false
	}

	/*!
		\qmlmethod bool Connection::go(int address)
		\brief Execute code at address \a address.

		Returns true on success, false otherwise.
	*/
	function go(address) {
		return false
	}

	/*!
		\qmlmethod bool Connection::waitForMonitor(int timeout)
		\brief Wait \a timeout milliseconds for monitor to be ready

		Some connection plugins do no implement this feature and will
		return \a true even when the monitor is not yet ready.

		Returns true on success, false otherwise.
	*/
	function waitForMonitor(timeout) {
		return false;
	}

	/*!
		\qmlmethod bool Connection::appletUpload(Applet applet)
		\brief Uploads an \a applet to the device.

		The applet code is written at the applet \tt codeAddr but no
		code is executed.

		Returns true on success, false otherwise.
	*/
	function appletUpload(new_applet)
	{
		applet = undefined

		var file = File.open(encodeURI(new_applet.codeUrl), false)
		var appletCode = file.readAll()
		file.close()
		if (!appletCode)
			return false

		if (write(new_applet.codeAddr, appletCode))
		{
			applet = new_applet
			return true
		}

		return false
	}

	/*!
		\qmlmethod int Connection::appletMailboxRead(int index)
		\brief Reads unsigned 32-bit word at index \a index in the applet mailbox.
	*/
	function appletMailboxRead(index)
	{
		if (!applet || index > 32)
			return 0
		return readu32(applet.mailboxAddr + (index + 2) * 4);
	}

	/*!
		\qmlmethod ByteArray Connection::appletBufferRead(int length)
		\brief Reads \a length bytes from the applet buffer.

		Returns the data on success, \tt undefined if an error occurred
		or if the requested length is greater than the current applet
		buffer size.
	*/
	function appletBufferRead(length)
	{
		if (!applet)
			return
		if (length > applet.bufferSize)
			return
		return read(applet.bufferAddr, length)
	}

	/*!
		\qmlmethod bool Connection::appletBufferWrite(ByteArray data)
		\brief Writes \a data into the applet buffer.

		Returns true on success, false if an error occurred or if the
		\a data length is greater than the current applet buffer.
	*/
	function appletBufferWrite(data)
	{
		if (!applet)
			return false
		if (data.byteLength > applet.bufferSize)
			return false
		return write(applet.bufferAddr, data)
	}

	/*!
		\qmlmethod int Connection::appletExecute(AppletCommand command, var arguments)
		\brief Execute applet \a command with \a arguments and poll for
		completion until the command has completed or its timeout is expired.

		Arguments can be supplied a single integer if there is only one
		argument, or an array of integers if multiple arguments are needed.

		After an applet command is started, the Connection will poll
		for applet completion until the requested timeout is expired.

		Returns the applet return code. Zero (0) is usually means
		success and anything else is an error.  The values of the error
		codes are applet-specific.  No value is returned if no applet
		is loaded, if the arguments types are invalid or if the applet
		command has not completed before the timeout was reached.
	*/
	function appletExecute(cmd, args)
	{
		if (!applet)
			return

		var mbxOffset = 0

		// write applet command / status
		writeu32(applet.mailboxAddr + mbxOffset, cmd.code)
		mbxOffset += 4
		writeu32(applet.mailboxAddr + mbxOffset, 0xffffffff)
		mbxOffset += 4

		// write applet arguments
		if (Array.isArray(args)) {
			for (var i = 0; i < args.length; i++) {
				writeu32(applet.mailboxAddr + mbxOffset, Utils.parseInteger(args[i]));
				mbxOffset += 4;
			}
		}
		else if (typeof args === "number") {
			writeu32(applet.mailboxAddr + mbxOffset, Utils.parseInteger(args))
			mbxOffset += 4
		}
		else
		{
			return
		}

		// run applet
		go(applet.entryAddr)

		// wait for device to go back to monitor
		var startTime = new Date().getTime()
		waitForMonitor(cmd.timeout)

		// wait for completion (waitForMonitor is not always reliable depending
		// on the connection type)
		var elapsed = 0
		while (elapsed < cmd.timeout) {
			var ack = readu32(applet.mailboxAddr, cmd.timeout - elapsed);
			if (ack === (0xffffffff - cmd.code)) {
				// return applet status
				return readu32(applet.mailboxAddr + 4)
			}

			Utils.msleep(5)
			elapsed = new Date().getTime() - startTime
		}
	}

	/*!
		\qmlmethod void Connection::initializeApplet(string appletName)
		\brief Loads and initializes the \a appletName applet for the
		currently selected device.

		Throws an \a Error if the applet is not found or could not be
		loaded/initialized.
	*/
	function initializeApplet(appletName)
	{
		var newapplet = device.applet(appletName)
		if (!newapplet)
			throw new Error("Applet " + appletName + " not found")

		if (applet !== newapplet) {
			if (!appletUpload(newapplet))
				throw new Error("Applet " + appletName + " could not be loaded")
		}

		applet.initialize()
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return ["read8", "read16", "read32", "read",
		        "write8", "write16", "write32", "write",
		        "execute"]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "read8") {
			return ["* read8 - read a byte",
			        "Syntax:",
			        "    read8:<addr>",
			        "Example:",
			        "    read8:0x200000  read a byte at address 0x200000"]
		}
		else if (command === "read16") {
			return ["* read16 - read a half-word (16-bit)",
			        "Syntax:",
			        "    read16:<addr>",
			        "Example:",
			        "    read16:0x200000  read a half-word at address 0x200000"]
		}
		else if (command === "read32") {
			return ["* read32 - read a word (32-bit)",
			        "Syntax:",
			        "    read32:<addr>",
			        "Example:",
			        "    read32:0x200000  read a word at address 0x200000"]
		}
		else if (command === "read") {
			return ["* read - read data into a file",
			        "Syntax:",
			        "    read:<filename>:<addr>:<length>",
			        "Example:",
			        "    read:test.bin:0x200000:512  read 512 bytes from address 0x200000 into file test.bin"]
		}
		else if (command === "write8") {
			return ["* write8 - write a byte",
			        "Syntax:",
			        "    write8:<addr>:<value>",
			        "Example:",
			        "    write8:0x200000:0x12  write byte 0x12 at address 0x200000"]
		}
		else if (command === "write16") {
			return ["* write16 - write a half-word (16-bit)",
			        "Syntax:",
			        "    write16:<addr>:<value>",
			        "Example:",
			        "    write16:0x200000:0x1234  write half-word 0x1234 at address 0x200000"]
		}
		else if (command === "write32") {
			return ["* write32 - write a word (32-bit)",
			        "Syntax:",
			        "    write32:<addr>:<value>",
			        "Example:",
			        "    write32:0x200000:0x12345678  write word 0x12345678 at address 0x200000"]
		}
		else if (command === "write") {
			return ["* write - write data from a file",
			        "Syntax:",
			        "    write:<filename>:<addr>",
			        "Example:",
			        "    write:test.bin:0x200000  write data from file test.bin to address 0x200000"]
		}
		else if (command === "execute") {
			return ["* execute - execute code",
			        "Syntax:",
			        "    execute:<addr>",
			        "Example:",
			        "    execute:0x200000  execute code at 0x200000"]
		}
	}

	/*! \internal */
	function commandLineCommandRead8(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = readu8(addr)
		if (typeof value !== "number")
			return "Failed to run command."
		print("read8(" + Utils.hex(addr, 2) + ")" + "=" +
		             Utils.hex(value, 2))
	}

	/*! \internal */
	function commandLineCommandRead16(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = readu16(addr)
		if (typeof value !== "number")
			return "Failed to run command."
		print("read16(" + Utils.hex(addr, 4) + ")" + "=" +
		             Utils.hex(value, 4))
	}

	/*! \internal */
	function commandLineCommandRead32(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = readu32(addr)
		if (typeof value !== "number")
			return "Failed to run command."
		print("read32(" + Utils.hex(addr, 8) + ")" + "=" +
		             Utils.hex(value, 8))
	}

	/*! \internal */
	function commandLineCommandRead(args) {
		if (args.length !== 3)
			return "Invalid number of arguments (expected 3)."

		var fileName = args[0]

		var addr = Utils.parseInteger(args[1])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."

		var length = Utils.parseInteger(args[2])
		if (isNaN(length))
			return "Invalid length parameter (not a number)."

		var file = File.open(fileName, true)
		if (!file)
			return "Could not open file '" + fileName + "' for writing."

		var data = read(addr, length)
		if (!data)
			return "Failed reading from device."

		if (file.write(data) !== data.byteLength)
			return "Failed writing to file."

		file.close()

		print("read(" + fileName + ", " + Utils.hex(addr, 8) + ", " +
		      Utils.hex(length, 8) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite8(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Utils.parseInteger(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu8(addr, (value & 0xff) >>> 0))
			return "Failed to run command."
		print("write16(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 2) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite16(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Utils.parseInteger(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu16(addr, (value & 0xffff) >>> 0))
			return "Failed to run command."
		print("write16(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 4) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite32(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Utils.parseInteger(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu32(addr, value))
			return "Failed to run command."
		print("write32(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 8) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."

		var fileName = args[0]

		var addr = Utils.parseInteger(args[1])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."

		var file = File.open(fileName, false)
		if (!file)
			throw new Error("Could not open file '" + fileName + "' for reading.")

		var data = file.read(file.size())
		if (data.byteLength != file.size())
			return "Failed reading from file."

		if (!write(addr, data))
			return "Failed writing to device."

		print("write(" + fileName + ", " + Utils.hex(addr, 8) + ")")
	}

	/*! \internal */
	function commandLineCommandExecute(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."
		var addr = Utils.parseInteger(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		if (!go(addr))
			return "Failed to run command."
		print("execute(" + Utils.hex(addr, 8) + ")")
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "read8")
			return commandLineCommandRead8(args)
		else if (command === "read16")
			return commandLineCommandRead16(args)
		else if (command === "read32")
			return commandLineCommandRead32(args)
		else if (command === "read")
			return commandLineCommandRead(args)
		else if (command === "write8")
			return commandLineCommandWrite8(args)
		else if (command === "write16")
			return commandLineCommandWrite16(args)
		else if (command === "write32")
			return commandLineCommandWrite32(args)
		else if (command === "write")
			return commandLineCommandWrite(args)
		else if (command === "execute")
			return commandLineCommandExecute(args)
		else
			return "Unknown command."
	}

	/*! \internal */
	onDeviceChanged: {
		applet = undefined
		if (typeof device !== "undefined")
			device.connection = this
	}

	/*! \internal */
	Component.onCompleted: {
		if (autoConnect)
			open()
	}

	/*! \internal */
	Component.onDestruction: {
		close()
	}
}
