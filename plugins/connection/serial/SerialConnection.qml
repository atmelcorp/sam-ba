import QtQuick 2.3
import SAMBA 3.0
import SAMBA.Connection.Serial 3.0

/*!
\qmltype SerialConnection
\inherits Connection
\inqmlmodule SAMBA.Connection.Serial
\brief SerialConnection represents a serial connection to a programmable
device, either via RS232 or USB.

SerialConnection can be used to connect to the SAM-BA Monitor included in the
ROM Code of most Atmel MPUs and MCUs.

The device must be waiting for commands in SAM-BA Monitor mode. This is
usually done by either erasing the device (for devices that have an internal
flash and a dedicated ERASE pin), or by disabling the chip-select of the
external memories. Please see the datasheets and manuals of the device and
board for more details.

This SAMBA::Connection implementation supports both direct USB connection to
the SAM-BA Monitor and access through the console UART. The console UART is
device-specific (for example DBGU for SAMA5D4) and may be configurable (on
SAMA5D2, the console can be changed using the boot config word and/or fuses).
Please see the datasheet of the device for more details.
*/
Connection {
	name: "serial"
	aliases: [ "usb", "at91" ]

	/*!
	\qmlproperty string SerialConnection::port
	\brief The port to use for the connection

	For Windows, port have the form "COMxx" where \e xx is the number
	assigned to the port, for example "COM2" or "COM84".

	For Linux, use the device name without its "/dev/" prefix, i.e. for
	"/dev/ttyACM0", use "ttyACM0".
	*/
	property alias port: helper.port

	/*!
	\qmlproperty int SerialConnection::baudRate
	\brief The serial baud rate to use for the connection.

	If the requested baudrate is not supported, the closest supported one
	will be used. When connected directly to the AT91 CDC ACM USB port, the
	baudrate is ignored.
	*/
	property alias baudRate: helper.baudRate

	function open() {
		helper.open()
	}

	function close() {
		helper.close()
	}

	function readu8(address) {
		return helper.readu8(address)
	}

	function readu16(address) {
		return helper.readu16(address)
	}

	function readu32(address) {
		return helper.readu32(address)
	}

	function read(address, length) {
		return helper.read(address, length)
	}

	function writeu8(address, data) {
		return helper.writeu8(address, data)
	}

	function writeu16(address, data) {
		return helper.writeu16(address, data)
	}

	function writeu32(address, data) {
		return helper.writeu32(address, data)
	}

	function write(address, data) {
		return helper.write(address, data)
	}

	function go(address) {
		return helper.go(address)
	}

	/*! \internal */
	function handle_helper_connectionOpened(at91) {
		appletConnectionType = !at91 ? ConnectionBase.Serial : ConnectionBase.USB
		connectionOpened()
	}

	/*! \internal */
	function handle_helper_connectionFailed(message) {
		connectionFailed(message)
	}

	/*! \internal */
	function handle_helper_connectionClosed(message) {
		connectionClosed(message)
	}

	SerialConnectionHelper {
		id: helper
		onConnectionOpened: parent.handle_helper_connectionOpened(at91)
		onConnectionFailed: parent.handle_helper_connectionFailed(message)
		onConnectionClosed: parent.handle_helper_connectionClosed()
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		switch (args.length) {
		case 2:
			if (args[1].length > 0) {
				baudRate = parseInt(args[1]);
				if (isNaN(props.baudRate))
					return "Invalid serial baudrate (not a number)"
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
		return ["Syntax: serial:[<port>]:[<baudrate>]",
				"Examples: serial -> serial port (will use first AT91 USB if found otherwise first serial port)",
				"          serial:COM80 -> serial port on COM80",
				"          serial:ttyUSB0:57600 -> serial port on /dev/ttyUSB0, baudrate 57600"]
	}
}
