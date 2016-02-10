import QtQuick 2.3
import SAMBA 3.0

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
	\li Read
	\li Write
	\li Verify
	\li Full Erase
	\li Partial Erase
	\li Set/Clear GPNVM
	\endlist

	Here is an example script using the AppletLoader to flash a file on the SPI
	flash of a SAMA5D2:

	\qml
	import SAMBA 3.0
	import SAMBA.Connection.Serial 3.0
	import SAMBA.Device.SAMA5D2 3.0

	AppletLoader {
		connection: SerialConnection { }

		device: SAMA5D2 { }

		onConnectionOpened: {
			appletInitialize("serialflash")
			appletErase(0, 1024 * 1024)
			appletWriteVerify(0, "program.bin", true)
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
	verify that it was flashed correctly. The third argument ("true")
	indicates that the file must be processed to be bootable.
	\endlist

	To ease the development of flashing scripts, all functions in AppletLoader
	throw a JavaScript \tt Error on failure.  This will effectively stop
	the script on error without having to handle error checking.
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

		Throws an \a Error if the applet is not found or could not be
		loaded/initialized.
	*/
	function appletInitialize(appletName)
	{
		var applet = device.applet(appletName)
		if (!applet)
			throw new Error("Applet " + appletName + " not found")

		if (!connection.appletUpload(applet))
			throw new Error("Applet " + appletName + " could not be loaded")

		if (connection.applet.canInitialize()) {
			connection.applet.initialize(connection, device)
			if (connection.applet.memorySize > 1)
				print("Detected memory size is " +
				      connection.applet.memorySize + " bytes.")
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletRead(int offset, int size, string fileName)
		\brief Read data from the device into a file.

		Reads \a size bytes at offset \a offset using the applet 'read'
		command and writes the data to a file named \a fileName.

		Throws an \a Error if the applet has no read command or if an
		error occured during reading
	*/
	function appletRead(offset, size, fileName)
	{
		if (!connection.applet.canReadPages())
			throw new Error("Applet '" + applet.name +
			                "' does not support 'read pages' command")

		if (offset & (connection.applet.pageSize - 1) != 0)
			throw new Error("Read offset is not page-aligned")
		offset /= connection.applet.pageSize

		// TODO handle non-page aligned sizes
		if ((size & (connection.applet.pageSize - 1)) !== 0)
			throw new Error("Read size is not page-aligned")
		size /= connection.applet.pageSize

		var data, percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0) {
			var count = Math.min(remaining, connection.applet.bufferPages)

			var result = connection.applet.readPages(connection, device,
			                                         offset, count)
			if (result.length < count * connection.applet.pageSize)
				count = result.length / connection.applet.pageSize

			if (count === 0) {
				if (badCount === 0)
					badOffset = offset
				badCount++
				offset++
				continue
			} else if (badCount > 0) {
				print("Skipped " + badCount + " bad page(s) at address 0x" +
				      (badOffset * connection.applet.pageSize).toString(16))
				badCount = 0
			}

			if (!data)
				data = result
			else
				data.append(result)

			percent = 100 * (1 - ((remaining - count) / size))
			print("Read " +
			      (count * connection.applet.pageSize) +
			      " bytes at address 0x" +
			      (offset * connection.applet.pageSize).toString(16) +
			      " (" + percent.toFixed(2) + "%)")

			offset += count
			remaining -= count
		}

		if (!data.writeFile(fileName))
			throw new Error("Could not write to file '" + fileName + "'")
	}

	/*!
		\qmlmethod void AppletLoader::appletWrite(int offset, string fileName, bool bootFile)
		\brief Writes data from a file to the device.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no write command or if an
		error occured during writing
	*/
	function appletWrite(offset, fileName, bootFile)
	{
		if (!connection.applet.canWritePages())
			throw new Error("Applet '" + connection.applet.name +
			                "' does not support 'buffer write' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read from file '" + fileName + "'")
		if (!!bootFile)
			connection.applet.prepareBootFile(connection, device, data)

		if (offset & (connection.applet.pageSize - 1) != 0)
			throw new Error("Write offset is not page-aligned")
		offset /= connection.applet.pageSize

		// handle input data padding
		if ((data.length & (connection.applet.pageSize - 1)) !== 0) {
			var padding = connection.applet.pageSize -
			              (data.length & (connection.applet.pageSize - 1))
			data.pad(padding, connection.applet.padding)
			print("Added " + padding + " bytes of padding to align to page size")
		}
		var size = data.length / connection.applet.pageSize

		var current = 0
		var percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0)
		{
			var count = Math.min(remaining, connection.applet.bufferPages)

			var pagesWritten = connection.applet.writePages(connection, device, offset,
					data.mid(current * connection.applet.pageSize,
					         count * connection.applet.pageSize))
			if (pagesWritten < count)
				count = pagesWritten

			if (count === 0) {
				if (badCount === 0)
					badOffset = offset
				badCount++
				offset++
				continue
			} else if (badCount > 0) {
				print("Skipped " + badCount + " bad page(s) at address 0x" +
				      (badOffset * connection.applet.pageSize).toString(16))
				badCount = 0
			}

			percent = 100 * (1 - ((remaining - count) / size))
			print("Wrote " +
			      (count * connection.applet.pageSize) +
			      " bytes at address 0x" +
			      (offset * connection.applet.pageSize).toString(16) +
			      " (" + percent.toFixed(2) + "%)")

			current += count
			offset += count
			remaining -= count
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletVerify(int offset, string fileName, bool bootFile)
		\brief Compares data between a file and the device memory.

		Reads the contents of the file named \a fileName and compares
		it with memory at offset \a offset using the applet 'read'
		command.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no read command, if an
		error occured during reading or if the verification failed.
	*/
	function appletVerify(offset, fileName, bootFile)
	{
		if (!connection.applet.canReadPages())
			throw new Error("Applet '" + connection.applet.name +
			                "' does not support 'read buffer' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read file '" + fileName + "'")
		if (!!bootFile)
			connection.applet.prepareBootFile(connection, device, data)

		if (offset & (connection.applet.pageSize - 1) != 0) {
			throw new Error("Verify offset is not page-aligned")
		}
		offset /= connection.applet.pageSize

		// handle input data padding
		if ((data.length & (connection.applet.pageSize - 1)) !== 0) {
			var padding = connection.applet.pageSize -
			              (data.length & (connection.applet.pageSize - 1))
			data.pad(padding, connection.applet.padding)
			print("Added " + padding + " bytes of padding to align to page size")
		}
		var size = data.length / connection.applet.pageSize

		var current = 0
		var percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0)
		{
			var count = Math.min(remaining, connection.applet.bufferPages)

			var result = connection.applet.readPages(connection, device, offset, count)
			if (result.length < count * connection.applet.pageSize)
				count = result.length / connection.applet.pageSize

			if (count === 0) {
				if (badCount === 0)
					badOffset = offset
				badCount++
				offset++
				continue
			} else if (badCount > 0) {
				print("Skipped " + badCount + " bad page(s) at address 0x" +
				      (badOffset * connection.applet.pageSize).toString(16))
				badCount = 0
			}

			for (var i = 0; i < result.length; i++)
				if (result.readu8(i) !== data.readu8(current * connection.applet.pageSize + i))
					throw new Error("Failed verification. First error at address 0x" +
					                (offset * connection.applet.pageSize + i).toString(16))

			percent = 100 * (1 - ((remaining - count) / size))
			print("Verified " +
			      (count * connection.applet.pageSize) +
			      " bytes at address 0x" +
			      (offset * connection.applet.pageSize).toString(16) +
			      " (" + percent.toFixed(2) + "%)")

			current += count
			offset += count
			remaining -= count
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletWriteVerify(int offset, string fileName, bool bootFile)
		\brief Writes/Compares data from a file to the device memory.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command. The data
		is then read back using the applet 'read' command and compared
		it with the expected data.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no read and write commands
		or if an error occured during reading, writing or verifying.
	*/
	function appletWriteVerify(offset, fileName, bootFile)
	{
		appletWrite(offset, fileName, bootFile)
		appletVerify(offset, fileName, bootFile)
	}

	/*!
		\qmlmethod void AppletLoader::appletErase(int offset, int size)
		\brief Erases a block of memory.

		Erases \a size bytes at offset \a offset using the applet
		'block erase' command.

		Throws an \a Error if the applet has no block erase command or
		if an error occured during erasing
	*/
	function appletErase(offset, size)
	{
		if (!connection.applet.canErasePages()) {
			throw new Error("Applet '" + connection.applet.name +
			                "' does not support 'erase pages' command")
		}

		// no offset supplied, start at 0
		if (typeof offset === "undefined") {
			offset = 0
		} else {
			if ((offset & (connection.applet.pageSize - 1)) !== 0)
				throw new Error("Offset is not page-aligned")
			offset /= connection.applet.pageSize
		}

		// no size supplied, do a full erase
		if (size === undefined) {
			size = connection.applet.memoryPages - offset
		} else {
			if ((size & (connection.applet.pageSize - 1)) !== 0)
				throw new Error("Size is not page-aligned")
			size /= connection.applet.pageSize
		}

		if ((offset + size) > connection.applet.memoryPages)
			throw new Error("Requested erase region overflows memory")

		var end = offset + size

		var plan = computeErasePlan(offset, end, false)
		if (plan === undefined)
			throw new Error("Cannot erase requested region using supported erase block sizes without overflow")

		for (var i in plan) {
			offset = plan[i].start
			for (var n = 0; n < plan[i].count; n++) {
				var count = connection.applet.erasePages(connection, device,
				                                         offset, plan[i].length)
				var percent = 100 * (1 - ((end - offset - count) / size))
				print("Erased " +
				      (count * connection.applet.pageSize) +
				      " bytes at address 0x" +
				      (offset * connection.applet.pageSize).toString(16) +
				      " (" + percent.toFixed(2) + "%)")
				offset += count
			}
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletFullErase()
		\brief Fully Erase the Device

		Completely erase the device using the applet 'full erase'
		command or several applet 'page erase' commands.

		Throws an \a Error if the applet has no Full Erase command or
		if an error occured during erase
	*/
	function appletFullErase()
	{
		if (connection.applet.canEraseAll()) {
			connection.applet.eraseAll(connection, device)
		} else if (connection.applet.canErasePages()) {
			appletErase()
		} else {
			throw new Error("Applet '" + connection.applet.name +
		                        "' does not support any erase command")
		}
	}

	/*!
		\qmlmethod void AppletLoader::appletGpnvmSet(int index)
		\brief Sets GPNVM.

		Sets GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during setting GPNVM
	*/
	function appletGpnvmSet(index)
	{
		if (!connection.applet.canSetGpnvm())
			throw new Error("Applet '" + connection.applet.name
					+ "' does not support 'Set GPNVM' command")
		connection.applet.setGpnvm(connection, device, index)
	}

	/*!
		\qmlmethod void AppletLoader::appletGpnvmClear(int index)
		\brief Clears GPNVM.

		Clears GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during clearing GPNVM
	*/
	function appletGpnvmClear(index)
	{
		if (!connection.applet.canClearGpnvm())
			throw new Error("Applet '" + connection.applet.name
					+ "' does not support 'Clear GPNVM' command")
		connection.applet.clearGpnvm(connection, device, index)
	}

	/*! \internal */
	function computeErasePlan(start, end, overflow) {
		var supported = []
		var i, size

		for (i = 32; i >= 0; i--) {
			size = 1 << i
			if ((connection.applet.eraseSupport & size) !== 0)
				supported.push(size)
		}

		var plan = []
		var currentStart = 0
		var currentSize = 0
		var currentCount = 0
		while (start < end) {
			var bestSize = 0
			for (i in supported) {
				size = supported[i]
				// skip unaligned
				if ((start & (size - 1)) !== 0)
					continue
				// skip too big
				if (start + size > end)
					continue
				bestSize = size
				break
			}

			if (!!overflow && bestSize === 0) {
				bestSize = supported[supported.length - 1]
				if (currentSize === 0) {
					start &= ~(bestSize - 1)
				}
			}

			if (bestSize === 0)
				return

			if (currentSize === bestSize) {
				currentCount++
			} else {
				if (currentSize !== 0) {
					plan.push({start:currentStart,
					           length:currentSize,
					           count:currentCount})
				}
				currentStart = start
				currentSize = bestSize
				currentCount = 1
			}

			start += bestSize
		}
		if (currentSize !== 0) {
			plan.push({start:currentStart,
			           length:currentSize,
			           count:currentCount})
		}
		return plan
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
