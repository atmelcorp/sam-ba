import QtQuick 2.3
import SAMBA 1.0

/*!
	\qmltype AppletLoader
	\inqmlmodule SAMBA
	\brief Generic loader/command execution for SAM-BA Applets.

	The AppletLoader QML type is provided to facilitate the use of
	\l{SAMBA::Applet}{SAM-BA Applets}.

	It combines a \l{SAMBA::}{Connection} and a \l{SAMBA::}{Device} and provides
	several functions to call the most common applet commands:
	\list
	\li Initialize
	\li Erase Block
	\li Read Block
	\li Write Block
	\li Full Erase
	\li Set/Clear GPNVM
	\endlist

	Here is an example script using the AppletLoader to flash a file on the SPI
	flash of a SAMA5D2:

	\qml
	import SAMBA 1.0
	import SAMBA.Connection.Serial 1.0
	import SAMBA.Device.SAMA5D2 1.0

	AppletLoader {
		connection: SerialConnection { }

		device: SAMA5D2 { }

		onConnectionOpened: {
			appletInitialize("serialflash")
			appletErase(0, 1024 * 1024)
			appletWriteVerify(0, "program.bin")
		}
	}
	\endqml

	The AppletLoader is created with a SerialConnection and a SAMA5D2 device using
	their default parameters.

	JavaScript code is connected to the \tt ConnectionOpened signal in order to:
	\list
	\li Load and initialize the "serialflash" applet
	\li Erase 1MB at offset 0
	\li Write the contents of file "program.bin" at offset 0 and read it back to
	verify that it was flashed correctly
	\endlist

	To ease the development of flashing scripts, all functions in AppletLoader
	throw a JavaScript \tt Error on failure.  This will effectively stop the script
	on error without having to handle error checking.
*/
Item {
	/*! Device whose applets will be used. */
	property Device device

	/*! Connection used to communicate with applets. */
	property Connection connection

	/*! Whether the connection should be automatically established on
		component completion. */
	property bool autoconnect: true

	/*! Raised when the connection has been opened */
	signal connectionOpened()

	/*! Raised when the connection fails to open.\br
		Failure reason is contained in \a message signal parameter. */
	signal connectionFailed(string message)

	/*! Raised when the connection was closed. */
	signal connectionClosed()

	/*!
		\qmlmethod void AppletLoader::appletInitialize(string appletName)
		\brief Loads and initializes the \a appletName applet.

		Throws an \a Error if the applet is not found or could not be loaded/initialized.
	*/
	function appletInitialize(appletName)
	{
		var applet = device.appletByName(appletName)
		if (!applet)
			throw new Error("Applet " + appletName + " not found")

		if (!connection.appletUpload(applet))
			throw new Error("Applet " + appletName + " could not be loaded")

		if (connection.applet.hasCommand("init"))
		{
			var status = connection.appletExecute("init", connection.applet.initArgs)
			if (status !== 0)
				throw new Error("Applet " + connection.applet.description + " failed to initialize (status=" + status + ")")

			if (connection.applet.kind === Applet.KindNVM ||
				connection.applet.kind === Applet.KindExtRAM)
			{
				connection.applet.memorySize = connection.appletMailboxRead(0)
				connection.applet.bufferAddr = connection.appletMailboxRead(1)
				connection.applet.bufferSize = connection.appletMailboxRead(2)
			}
			else
			{
				connection.applet.memorySize = 0
				connection.applet.bufferAddr = 0
				connection.applet.bufferSize = 0
			}

			print("Applet " + connection.applet.description + " loaded and initialized.")
			if (connection.applet.memorySize > 0)
				print("Memory size is " + connection.applet.memorySize + " bytes.")
		}
		else
		{
			print("Applet " + connection.applet.description + " loaded.")
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletRead(int offset, int size, string fileName)
		\brief Read data from the device into a file.

		Reads \a size bytes at offset \a offset using the applet 'read'
		command and writes the data to a file named \a fileName.

		Throws an \a Error if the applet has no read command or if an error occured during reading
	*/
	function appletRead(offset, size, fileName)
	{
		if (!connection.applet.hasCommand("read"))
			throw new Error("Applet '" + applet.name + "' does not support 'read' command")

		if (offset + size > connection.applet.memorySize)
		{
			var remaining = connection.applet.memorySize - offset
			throw new Error("Cannot read past end of memory, only " +
				  remaining + " bytes remaining at offset 0x" +
				  offset.toString(16) + " (requested " + size + " bytes)")
		}

		var data
		while (size > 0)
		{
			var count = Math.min(size, connection.applet.bufferSize)

			var status = connection.appletExecute("read", [ connection.applet.bufferAddr, count, offset ])
			if (status !== 0)
				throw new Error("Failed to read block at address 0x" + offset.toString(16) + "(status: " + status + ")")

			var block = connection.appletBufferRead(count)
			if (block.length < count)
				throw new Error("Could not read from applet buffer")
			if (!data)
				data = block
			else
				data.append(block)

			print("Read " + count + " bytes at address 0x" + offset.toString(16))

			offset += count
			size -= count
		}

		if (!data.writeFile(fileName))
			throw new Error("Could not write to file '" + fileName + "'")
	}

	/*!
		\qmlmethod void AppletLoader::appletWrite(int offset, string fileName)
		\brief Writes data from a file to the device.

		Reads the contents of the file named \a fileName and writes it at offset
		\a offset using the applet 'write' command.

		Throws an \a Error if the applet has no write command or if an error occured during writing
	*/
	function appletWrite(offset, fileName)
	{
		if (!connection.applet.hasCommand("write"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'write' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read from file '" + fileName + "'")

		var size = data.length
		if (offset + size > connection.applet.memorySize)
		{
			var remaining = connection.applet.memorySize - offset
			throw new Error("Cannot write past end of memory, only " +
				  remaining + " bytes remaining at offset 0x" +
				  offset.toString(16) + " (file size is " + size + " bytes)")
		}

		var current = 0
		while (size > 0)
		{
			var count = Math.min(size, connection.applet.bufferSize)

			if (!connection.appletBufferWrite(data.mid(current, count)))
				throw new Error("Could not write to applet buffer")

			var status = connection.appletExecute("write", [ connection.applet.bufferAddr, count, offset ])
			if (status !== 0)
				throw new Error("Failed to write block at address 0x" + offset.toString(16) + "(status: " + status + ")")

			print("Wrote " + count + " bytes at address 0x" + offset.toString(16));

			current += count
			offset += count
			size -= count
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletVerify(int offset, string fileName)
		\brief Compares data between a file and the device memory.

		Reads the contents of the file named \a fileName and compares it with memory at offset
		\a offset using the applet 'read' command.

		Throws an \a Error if the applet has no read command, if an error occured during reading or if the verification failed.
	*/
	function appletVerify(offset, fileName)
	{
		if (!connection.applet.hasCommand("read"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'read' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read file '" + fileName + "'")

		var size = data.length
		if (offset + size > connection.applet.memorySize)
		{
			var remaining = connection.applet.memorySize - offset
			throw new Error("Cannot verify past end of memory, only " +
				  remaining + " bytes remaining at offset 0x" +
				  offset.toString(16) + " (file size is " + size + " bytes)");
		}

		var current = 0
		while (size > 0)
		{
			var count = Math.min(size, connection.applet.bufferSize)

			var status = connection.appletExecute("read", [ connection.applet.bufferAddr, count, offset ])
			if (status !== 0)
				throw new Error("Could not read block at address 0x" + offset.toString(16) + "(status: " + status + ")");

			var block = connection.appletBufferRead(count)
			if (block.length < count)
				throw new Error("Could not read from applet buffer");

			for (var i = 0; i < block.length; i++)
				if (block.readu8(i) !== data.readu8(offset + i))
					throw new Error("Failed verification. First error at address 0x" + (offset + i).toString(16));

			print("Verified " + count + " bytes at address 0x" + offset.toString(16));

			current += count
			offset += count
			size -= count
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletWriteVerify(int offset, string fileName)
		\brief Writes/Compares data from a file to the device memory.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command. The data is then read
		back using the applet 'read' command and compared it with the expected data.

		Throws an \a Error if the applet has no read and write commands or if an error occured during reading, writing or verifying.
	*/
	function appletWriteVerify(offset, fileName)
	{
		appletWrite(offset, fileName)
		appletVerify(offset, fileName)
	}

	/*!
		\qmlmethod void AppletLoader::appletErase(int offset, int size)
		\brief Erases a block of memory.

		Erases \a size bytes at offset \a offset using the applet 'block erase' command.

		Throws an \a Error if the applet has no block erase command or if an error occured during erasing
	*/
	function appletErase(offset, size)
	{
		if (!connection.applet.hasCommand("blockErase"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'block erase' command")

		if (offset > connection.applet.memorySize)
			throw new Error("Offset is past end of memory");

		// at least one byte (=> 1 block)
		if (size === undefined)
			size = 1

		var end = offset + size
		while (offset < end) {
			var status = connection.appletExecute("blockErase", offset)
			if (status !== 0)
				throw new Error("Could not erase block at address 0x" + offset.toString(16) + " (status: " + status + ")");

			var count = connection.appletMailboxRead(0)
			if (count === 0)
				throw new Error("Could not erase block at address 0x" + offset.toString(16) + " (applet returned success but 0 bytes erased)");

			print("Erased " + count + " bytes at address 0x" + offset.toString(16));
			offset += count
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletFullErase()
		\brief Fully Erase the Device

		Completely erase the device using the applet 'full erase' command.

		Throws an \a Error if the applet has no Full Erase command or if an error occured during erase
	*/
	function appletFullErase()
	{
		if (!connection.applet.hasCommand("fullErase"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'full erase' command")
		var status = connection.appletExecute("fullErase")
		if (status !== 0)
			throw new Error("Full Erase command failed (status=" + status + ")")
	}

	/*!
		\qmlmethod void AppletLoader::appletGpnvmSet(int index)
		\brief Sets GPNVM.

		Sets GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an error occured during setting GPNVM
	*/
	function appletGpnvmSet(index)
	{
		if (!connection.applet.hasCommand("gpnvm"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'GPNVM' command")
		var status = connection.appletExecute("gpnvm", [ 1, index ])
		if (status !== 0)
			throw new Error("GPNVM Set command failed (status=" + status + ")")
	}

	/*!
		\qmlmethod void AppletLoader::appletGpnvmClear(int index)
		\brief Clears GPNVM.

		Clears GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an error occured during clearing GPNVM
	*/
	function appletGpnvmClear(index)
	{
		if (!connection.applet.hasCommand("gpnvm"))
			throw new Error("Applet '" + connection.applet.name + "' does not support 'GPNVM' command")
		var status = connection.appletExecute("gpnvm", [ 0, index ])
		if (status !== 0)
			throw new Error("GPNVM Clear command failed (status=" + status + ")")
	}

	/*! \internal */
	function handle_connectionOpened()
	{
		print("Connection opened.")
		device.initialize(connection)
		connectionOpened()
	}

	/*! \internal */
	function handle_connectionFailed(message)
	{
		print(message)
		connectionFailed(message)
	}

	/*! \internal */
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
			connection.open()
	}

	Component.onDestruction: {
		connection.close()
	}
}
