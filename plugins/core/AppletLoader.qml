import QtQuick 2.3
import SAMBA 1.0

Item {
	property Device device
	property Connection connection

	property bool autoconnect: true
	property int retries: 20
	property int appletTraceLevel: 4

	property Applet currentApplet
	property bool currentAppletLoaded: false
	property bool currentAppletInitialized: false

	signal connectionOpened()
	signal connectionFailed(string message)
	signal connectionClosed()

	function openConnection()
	{
		connection.open()
	}

	function closeConnection()
	{
		connection.close()
	}

	// Applet Handling

	function appletInitialize(appletName)
	{
		if (currentApplet && currentApplet.name !== appletName) {
			currentAppletLoaded = false
			currentAppletInitialized = false
			currentApplet = null
		}

		if (!currentApplet) {
			currentApplet = device.appletByName(appletName)
			if (!currentApplet) {
				print("Error: Applet " + appletName + " not found")
				return false
			}
		}

		if (!currentAppletLoaded) {
			var appletData = Utils.readUrl(currentApplet.fileUrl)
			connection.write(currentApplet.appletAddress, appletData)
			currentAppletLoaded = true
		}

		if (!currentAppletInitialized) {
			if (typeof currentApplet.initCommand !== undefined){
				var status = appletExecute(currentApplet.initCommand, currentApplet.initArgs)
				if (status !== AppletStatus.success) {
					print("Error: Applet " + currentApplet.description + " failed to initialize.")
					return false
				}
			}
			currentAppletInitialized = true
			print(currentApplet.description + " initialization done.")
			if (currentApplet.kind == AppletKind.nvm ||
				currentApplet.kind == AppletKind.extram)
				print("Memory size is " + currentApplet.memorySize + " bytes.")
		}

		return true
	}

	function appletReadMailbox(index)
	{
		return connection.readu32(currentApplet.mailboxAddress + (index + 2) * 4)
	}

	function appletExecute(cmd, args)
	{
		var mailboxArgsOffset = 8

		// write applet command / status
		connection.writeu32(currentApplet.mailboxAddress, cmd)
		connection.writeu32(currentApplet.mailboxAddress + 4, 0xffffffff)

		// write comm type / trace level if command is "Initialize"
		if (cmd === currentApplet.initCommand)
		{
			connection.writeu32(currentApplet.mailboxAddress + mailboxArgsOffset, connection.appletCommType())
			connection.writeu32(currentApplet.mailboxAddress + mailboxArgsOffset + 4, appletTraceLevel)
			mailboxArgsOffset += 8
		}

		// write applet arguments
		if (typeof args === "number")
		{
			connection.writeu32(currentApplet.mailboxAddress + mailboxArgsOffset, args)
		}
		else if (Array.isArray(args))
		{
			for (var i = 0; i < args.length; i++)
			{
				connection.writeu32(currentApplet.mailboxAddress + mailboxArgsOffset + i * 4, args[i])
			}
		}

		// run applet
		connection.go(currentApplet.appletAddress)

		// wait for completion
		var delay = 100
		for (var retry = 0; retry < retries; retry++)
		{
			if (retry > 0)
			{
				Utils.usleep(delay)
				delay *= 1.5
			}

			var ack = connection.readu32(currentApplet.mailboxAddress)
			if (ack === (0xffffffff - cmd))
				break
		}
		if (retry == retries)
		{
			print("Error: applet " + currentApplet.name + " command " + cmd + " did not complete in time")
			return AppletStatus.generic_fail
		}

		// return applet status
		var status = connection.reads32(currentApplet.mailboxAddress + 4)
		if (cmd === currentApplet.initCommand &&
			status === AppletStatus.success)
		{
			if (currentApplet.kind == AppletKind.nvm ||
				currentApplet.kind == AppletKind.extram)
			{
				currentApplet.memorySize = appletReadMailbox(0)
				currentApplet.bufferAddress = appletReadMailbox(1)
				currentApplet.bufferSize = appletReadMailbox(2)
			}
		}

		return status
	}

	function appletRead(offset, size, fileName)
	{
		if (typeof currentApplet.readCommand === "undefined")
		{
			print("Applet '" + currentApplet.name + "' does not support 'read' command")
			return false
		}

		if (offset + size > currentApplet.memorySize)
		{
			var remaining = currentApplet.memorySize - offset
			print("Cannot read past end of memory, only " +
				  remaining + " bytes remaining at offset 0x" +
				  offset.toString(16) + " (requested " + size + " bytes)");
			return false
		}

		var data
		while (size > 0)
		{
			var count = Math.min(size, currentApplet.bufferSize)

			var status = appletExecute(currentApplet.readCommand, [ currentApplet.bufferAddress, count, offset ])
			if (status !== AppletStatus.success) {
				print("Failed to read block at address 0x" + offset.toString(16) + "(status: " + status + ")");
				return false
			}

			var block = connection.read(currentApplet.bufferAddress, count)
			if (block.length() < count) {
				print("Failed reading applet buffer");
				return false
			}
			if (!data)
				data = block
			else
				data.append(block)

			print("Read " + count + " bytes at address 0x" + offset.toString(16));

			offset += count
			size -= count
		}

		if (!data.writeFile(fileName))
			return false

		return true
	}

	function appletWrite(offset, fileName)
	{
		if (typeof currentApplet.writeCommand === "undefined")
		{
			print("Applet '" + currentApplet.name + "' does not support 'write' command")
			return false
		}

		var data = Utils.readFile(fileName)
		if (!data)
			return false

		var size = data.length()
		if (offset + size > currentApplet.memorySize)
		{
			var remaining = currentApplet.memorySize - offset
			print("Cannot write past end of memory, only " +
				  remaining + " bytes remaining at offset 0x" +
				  offset.toString(16) + " (file size is " + size + " bytes)");
			return false
		}

		var current = 0
		while (size > 0)
		{
			var count = Math.min(size, currentApplet.bufferSize)

			if (!connection.write(currentApplet.bufferAddress, data.mid(current, count)))
				return AppletStatus.generic_fail

			var status = appletExecute(currentApplet.writeCommand, [ currentApplet.bufferAddress, count, offset ])
			if (status !== AppletStatus.success) {
				print("Failed to write block at address 0x" + offset.toString(16) + "(status: " + status + ")");
				return false
			}

			print("Wrote " + count + " bytes at address 0x" + offset.toString(16));

			current += count
			offset += count
			size -= count
		}

		return true
	}

	function appletErase(offset, size)
	{
		if (typeof currentApplet.blockEraseCommand === "undefined")
		{
			print("Applet '" + currentApplet.name + "' does not support 'block erase' command")
			return false
		}

		if (offset > currentApplet.memorySize)
		{
			//qCCritical(sambaLogApplet, "Error: trying to erase past end of memory");
			return false
		}

		// at least one byte (=> 1 block)
		if (size === undefined)
			size = 1

		var end = offset + size
		while (offset < end) {
			var status = appletExecute(currentApplet.blockEraseCommand, offset)
			if (status !== AppletStatus.success) {
				print("Failed to erase block at address 0x" + offset.toString(16) + " (status: " + status + ")");
				return false
			}

			var count = appletReadMailbox(0)
			print("Erased " + count + " bytes at address 0x" + offset.toString(16));

			offset += count
		}

		return true
	}

	function appletGpnvmSet(index)
	{
		if (typeof currentApplet.gpnvmCommand === "undefined")
		{
			print("Applet '" + currentApplet.name + "' does not support 'GPNVM' command")
			return false
		}
		return (appletExecute(currentApplet.gpnvmCommand, [ 1, index ]) === AppletStatus.success)
	}

	function appletGpnvmClear(index)
	{
		if (typeof currentApplet.gpnvmCommand === "undefined")
		{
			print("Applet '" + currentApplet.name + "' does not support 'GPNVM' command")
			return false
		}
		return (appletExecute(currentApplet.gpnvmCommand, [ 0, index ]) === AppletStatus.success)
	}

	function handle_connectionOpened()
	{
		print("Connection opened.")
		device.initialize(connection)
		connectionOpened()
	}

	function handle_connectionFailed(message)
	{
		print(message)
		connectionFailed(message)
	}

	function handle_connectionClosed()
	{
		print("Connection closed.")
		connectionClosed()
	}

	Component.onCompleted: {
		connection.connectionOpened.connect(handle_connectionOpened)
		connection.connectionFailed.connect(handle_connectionFailed)
		connection.connectionClosed.connect(handle_connectionClosed)
		if (autoconnect)
			openConnection()
	}

	Component.onDestruction: {
		closeConnection()
	}
}
