import QtQuick 2.3
import SAMBA 1.0
import SAMBA.Connection.JLink 1.0

Connection {
	id: connection
	property bool swd: false

	JLinkConnectionHelper {
		id: helper
		onConnectionOpened: connection.connectionOpened()
		onConnectionFailed: connection.connectionFailed(message)
		onConnectionClosed: connection.connectionClosed()
	}

	function availablePorts()
	{
		return helper.availablePorts()
	}

	// Connection

	function open()
	{
		return helper.open(port, swd)
	}

	function close()
	{
		helper.close()
	}

	// Memory read

	function read(address, length)
	{
		return helper.read(address, length)
	}

	function readu8(address)
	{
		return helper.readu8(address)
	}

	function readu16(address)
	{
		return helper.readu16(address)
	}

	function readu32(address)
	{
		return helper.readu32(address)
	}

	function reads8(address)
	{
		return helper.reads8(address)
	}

	function reads16(address)
	{
		return helper.reads16(address)
	}

	function reads32(address)
	{
		return helper.reads32(address)
	}

	// Memory write

	function write(address, data)
	{
		return helper.write(address, data)
	}

	function writeu8(address, data)
	{
		return helper.writeu8(address, data)
	}

	function writeu16(address, data)
	{
		return helper.writeu16(address, data)
	}

	function writeu32(address, data)
	{
		return helper.writeu32(address, data)
	}

	function writes8(address, data)
	{
		return helper.writes8(address, data)
	}

	function writes16(address, data)
	{
		return helper.writes16(address, data)
	}

	function writes32(address, data)
	{
		return helper.writes32(address, data)
	}

	// Execute

	function go(address)
	{
		return helper.go(address)
	}

	// Applet Handling

	function appletCommType()
	{
		return AppletCommType.jtag
	}
}
