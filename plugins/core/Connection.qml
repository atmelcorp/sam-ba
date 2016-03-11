import QtQuick 2.3
import SAMBA 3.0

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

It is recommended to use the AppletLoader helper type when using applets. It contains several methods to facilitate communication with applets.
*/
ConnectionBase {
	/*!
	\qmlproperty Applet Connection::applet
	\brief The current applet, or \tt undefined if no applet is loaded.
	*/

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

	On success, the connectionOpened signal will be raised.  If an error occurrs,
	the connectionFailed signal will be raised with the failure cause as argument.
	*/
	function open() {
		connectionFailed("open() not implemented on base Connection object.")
	}

	/*!
	\qmlmethod void Connection::close()
	\brief Closes the connection.

	The connectionClosed signal will be raised when the connection is closed.
	*/
	function close() {
		// do nothing
	}

	/*!
	\qmlmethod int Connection::readu8(int address)
	\brief Read a single unsigned byte at the given \a address.
	*/
	function readu8(address) {
		return
	}

	/*!
	\qmlmethod int Connection::readu16(int address)
	\brief Read a single unsigned 16-bit word at the given \a address.
	*/
	function readu16(address) {
		return
	}

	/*!
	\qmlmethod int Connection::readu32(int address)
	\brief Read a single unsigned 32-bit word at the given \a address.
	*/
	function readu32(address) {
		return
	}

	/*!
	\qmlmethod ByteArray Connection::read(int address, int length)
	\brief Read \a length bytes at address \a address.

	Returns a ByteArray with the data on success, or \tt undefined if an error
	occured.
	*/
	function read(address, length) {
		return
	}

	/*!
	\qmlmethod bool Connection::writeu8(int address, int data)
	\brief Write unsigned byte \a data at address \a address.

	Returns true on success, false otherwise.
	*/
	function writeu8(address, data) {
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
	\qmlmethod bool Connection::appletUpload(Applet applet)
	\brief Uploads an \a applet to the device.

	The applet code is written at the applet \tt codeAddr but not code is executed.

	Returns true on success, false otherwise.
	*/
	function appletUpload(new_applet)
	{
		applet = undefined

		var appletCode = Utils.readUrl(new_applet.codeUrl)
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

	Returns the data on success, \tt undefined if an error occurred or if the
	requested length is greater than the current applet buffer size.
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

	Returns true on success, false if an error occurred or if the \a data length is
	greater than the current applet buffer.
	*/
	function appletBufferWrite(data)
	{
		if (!applet)
			return false
		if (data.length > applet.bufferSize)
			return false
		return write(applet.bufferAddr, data)
	}

	/*!
	\qmlmethod int Connection::appletExecute(string command, var arguments, int retries)
	\brief Execute applet \a command with \a arguments and try \a retries times to
	poll for completion.

	Arguments can be supplied a single integer if there is only one
	argument, or an array of integers if multiple arguments are needed.

	After an applet command is started, the Connection will poll for applet
	completion using an adaptative timeout between poll cycles.  First polling is
	done just after command execution, subsequent retries will wait before checking
	for completion.  The initial delay is 100 microseconds and is multiplied by 1.5
	at each iteration until the command is complete or the maximum number of
	retries is reached.  The default number of retries if not specified is 20.

	Returns the applet return code. Zero (0) is usually means success and anything
	else is an error.  The values of the error codes are applet-specific and -1 is
	returned for unsupported commands or when the maximum number of polling retries
	was reached.
	*/
	function appletExecute(cmd, args, retries)
	{
		if (!applet)
			return
		if (!applet.hasCommand(cmd))
			return

		var cmdValue = applet.command(cmd)
		var mbxOffset = 0

		// write applet command / status
		writeu32(applet.mailboxAddr + mbxOffset, cmdValue)
		mbxOffset += 4
		writeu32(applet.mailboxAddr + mbxOffset, 0xffffffff)
		mbxOffset += 4

		// write applet arguments
		if (Array.isArray(args)) {
			for (var i = 0; i < args.length; i++) {
				writeu32(applet.mailboxAddr + mbxOffset, Number(args[i]));
				mbxOffset += 4;
			}
		}
		else if (typeof args === "number") {
			writeu32(applet.mailboxAddr + mbxOffset, Number(args))
			mbxOffset += 4
		}
		else
		{
			return
		}

		// run applet
		go(applet.codeAddr)

		// wait for completion
		var delay = 100
		var retry = 0
		for (retry = 0; retry < retries; retry++)
		{
			if (retry > 0)
			{
				Utils.usleep(delay)
				delay *= 1.5
			}

			var ack = readu32(applet.mailboxAddr);
			if (ack === (0xffffffff - cmdValue))
				break
		}
		if (retry === retries)
			return

		// return applet status
		return readu32(applet.mailboxAddr + 4)
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return ["read8", "read16", "read32",
				"write8", "write16", "write32"]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "read8") {
			return ["* read8 - read a byte",
			        "    syntax: read8:<addr>",
			        "    example: read8:0x200000"]
		}
		else if (command === "read16") {
			return ["* read16 - read a half-word (16-bit)",
			        "    syntax: read16:<addr>",
			        "    example: read16:0x200000"]
		}
		else if (command === "read32") {
			return ["* read32 - read a word (32-bit)",
			        "    syntax: read32:<addr>",
			        "    example: read32:0x200000"]
		}
		else if (command === "write8") {
			return ["* write8 - write a byte",
			        "    syntax: write8:<addr>:<value>",
			        "    example: write8:0x200000:0x12"]
		}
		else if (command === "write16") {
			return ["* write16 - write a half-word (16-bit)",
			        "    syntax: write16:<addr>:<value>",
			        "    example: write16:0x200000:0x1234"]
		}
		else if (command === "write32") {
			return ["* write32 - write a word (32-bit)",
			        "    syntax: write32:<addr>:<value>",
			        "    example: write32:0x200000:0x12345678"]
		}
	}

	/*! \internal */
	function commandLineCommandRead8(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."
		var addr = Number(args[0])
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
		var addr = Number(args[0])
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
		var addr = Number(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = readu32(addr)
		if (typeof value !== "number")
			return "Failed to run command."
		print("read32(" + Utils.hex(addr, 8) + ")" + "=" +
		             Utils.hex(value, 8))
	}

	/*! \internal */
	function commandLineCommandWrite8(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Number(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Number(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu8(addr, value & 0xff))
			return "Failed to run command."
		print("write16(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 2) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite16(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Number(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Number(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu16(addr, value & 0xffff))
			return "Failed to run command."
		print("write16(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 4) + ")")
	}

	/*! \internal */
	function commandLineCommandWrite32(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."
		var addr = Number(args[0])
		if (isNaN(addr))
			return "Invalid address parameter (not a number)."
		var value = Number(args[1])
		if (isNaN(value))
			return "Invalid value parameter (not a number)."
		if (!writeu32(addr, value))
			return "Failed to run command."
		print("write32(" + Utils.hex(addr, 8) + "," +
		             Utils.hex(value, 8) + ")")
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "read8")
			return commandLineCommandRead8(args)
		else if (command === "read16")
			return commandLineCommandRead16(args)
		else if (command === "read32")
			return commandLineCommandRead32(args)
		else if (command === "write8")
			return commandLineCommandWrite8(args)
		else if (command === "write16")
			return commandLineCommandWrite16(args)
		else if (command === "write32")
			return commandLineCommandWrite32(args)
		else
			return "Unknown command."
	}
}
