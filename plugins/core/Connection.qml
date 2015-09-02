import QtQuick 2.3
import SAMBA 1.0

Item {
	property string port

	signal connectionOpened()
	signal connectionFailed(string message)
	signal connectionClosed()

	function availablePorts()
	{
		return []
	}

	// Connection

	function open()
	{
		return false
	}

	function close()
	{
		// nothing here
	}

	// Memory read

	function read(address, length)
	{
		return []
	}

	function readu8(address)
	{
		return 0
	}

	function readu16(address)
	{
		return 0
	}

	function readu32(address)
	{
		return 0
	}

	function reads8(address)
	{
		return 0
	}

	function reads16(address)
	{
		return 0
	}

	function reads32(address)
	{
		return 0
	}

	// Memory write

	function write(address, data)
	{
		return false
	}

	function writeu8(address, data)
	{
		return false
	}

	function writeu16(address, data)
	{
		return false
	}

	function writeu32(address, data)
	{
		return false
	}

	function writes8(address, data)
	{
		return false
	}

	function writes16(address, data)
	{
		return false
	}

	function writes32(address, data)
	{
		return false
	}

	// Execute

	function go(address)
	{
		return false
	}

	// Applet

	function appletCommType()
	{
		return SambaApplet.serial
	}
}
