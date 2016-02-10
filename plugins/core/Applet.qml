import QtQuick 2.3
import SAMBA 3.0

/*!
	\qmltype Applet
	\inqmlmodule SAMBA
	\brief TODO
*/
AbstractApplet {
	/*!
		\qmlmethod void Applet::defaultInitArgs(Connection connection, Device device)
		\brief Returns the default input mailbox for applet initialization

		The default mailbox contains the connection type followed by the trace level.
		This method is called by the default buildInitArgs implementation.
	*/
	function defaultInitArgs(connection, device) {
		return [connection.appletConnectionType(), traceLevel]
	}

	/*!
		\qmlmethod void Applet::buildInitArgs(Connection connection, Device device)
		\brief Returns the input mailbox for applet initialization

		This default implementation just calls defaultInitArgs.
		It is intended to be overridden by Applet
		sub-classes/instances.
	*/
	function buildInitArgs(connection, device) {
		return defaultInitArgs(connection, device)
	}

	/*!
		\qmlmethod void Applet::patch6thVector(ByteArray data)
		\brief Change the 6th vector of a boot file to contain its size
	*/
	function patch6thVector(data) {
		// write size into 6th vector
		data.writeu32(20, data.length)
		print("Patched file length (" + data.length + ") at offset 20")
	}

	/*!
		\qmlmethod void Applet::prepareBootFile(Connection connection, Device device, ByteArray data)
		\brief Prepare a application file for use as a boot file

		The default implementation calls patch6thVector.
		It is intended to be overridden by Applet
		sub-classes/instances.
	*/
	function prepareBootFile(connection, device, data) {
		patch6thVector(data)
	}

	/*!
		\qmlmethod void Applet::canInitialize()
		\brief Check is the applet supports the 'initialize' command

		Returns a boolean value indicating if the 'initialize' command
		is supported.
	*/
	function canInitialize() {
		return hasCommand("initialize") ||
		       hasCommand("legacyInitialize")
	}

	function initialize(connection, device) {
		var args = buildInitArgs(connection, device)
		if (hasCommand("initialize")) {
			var status = connection.appletExecute("initialize",
			                                      args, retries)
			if (status === 0) {
				bufferAddr = connection.appletMailboxRead(0)
				bufferSize = connection.appletMailboxRead(1)
				pageSize = connection.appletMailboxRead(2)
				memoryPages = connection.appletMailboxRead(3)
				eraseSupport = connection.appletMailboxRead(4)
			} else {
				memorySize = 0
				bufferAddr = 0
				bufferSize = 0
				pageSize = 0
				eraseSupport = 0
				throw new Error("Could not initialize applet" +
						" (status: " + status + ")");
			}
		} else if (hasCommand("legacyInitialize")) {
			if (name === "lowlevel")
				args.push(0, 0, 0)
			var status = connection.appletExecute("legacyInitialize",
			                                      args, retries)
			if (status === 0) {
				memorySize = connection.appletMailboxRead(0)
				bufferAddr = connection.appletMailboxRead(1)
				bufferSize = connection.appletMailboxRead(2)
			} else {
				memorySize = 0
				bufferAddr = 0
				bufferSize = 0
				throw new Error("Could not initialize applet " +
						name + " (status: " + status + ")")
			}
			return
		} else {
			throw new Error("Applet does not support 'Initialize' command")
		}
	}

	/*!
		\qmlmethod void Applet::canEraseAll()
		\brief Check is the applet supports the 'erase all' command

		Returns a boolean value indicating if the 'erase all' command
		is supported.
	*/
	function canEraseAll() {
		return hasCommand("legacyEraseAll")
	}

	/*!
		\qmlmethod void Applet::eraseAll(Connection connection, Device device)
		\brief Fully erase the device

		Throws an \a Error if the 'erase all' command is not supported
		or if an error occurs during the erase operation.
	*/
	function eraseAll(connection, device) {
		if (hasCommand("legacyEraseAll")) {
			var status = connection.appletExecute("legacyEraseAll",
			                                      [], retries * 2)
			if (status !== 0)
				throw new Error("Failed to fully erase device " +
						"(status: " + status + ")")
		} else {
			throw new Error("Applet does not support 'Erase All' command")
		}
	}

	/*!
		\qmlmethod void Applet::canErasePages()
		\brief Check is the applet supports the 'erase pages' command

		Returns a boolean value indicating if the 'erase pages' command
		is supported.
	*/
	function canErasePages() {
		return hasCommand("erasePages")
	}

	/*!
		\qmlmethod void Applet::erasePages(Connection connection, Device device, int pageOffset, int length)
		\brief Erase \a length pages at \a pageOffset

		The \a length parameter contains the number of pages to erase
		and it must be one of the supported erase sizes of the
		applet/device.

		Returns the number of pages erased.

		Throws an \a Error if the 'erase page' command is not supported
		or if an error occurs during the erase operation.
	*/
	function erasePages(connection, device, pageOffset, length) {
		if (hasCommand("erasePages")) {
			var args = [pageOffset, length]
			var status = connection.appletExecute("erasePages",
			                                      args, retries)
			if (status === 0) {
				return connection.appletMailboxRead(0)
			} else if (status === 9) {
				print("Skipped bad pages at offset 0x" +
				      (pageOffset * pageSize).toString(16));
				return length
			} else {
				throw new Error("Could not erase pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (status: " + status + ")");
			}
		} else {
			throw new Error("Applet does not support 'Erase Pages' command")
		}
	}

	/*!
		\qmlmethod void Applet::canReadPages()
		\brief Check is the applet supports a read command

		Returns a boolean value indicating whether a read command is
		supported.
	*/
	function canReadPages() {
		return hasCommand("readPages") ||
		       hasCommand("legacyReadBuffer")
	}

	/*!
		\qmlmethod void Applet::readPages(Connection connection, Device device, int pageOffset, int length)
		\brief Read \a length pages at \a pageOffset

		The \a length parameter contains the number of pages to read.

		Returns a \a ByteArray containing the pages read.

		Throws an \a Error if no read command is supported or if an
		error occurs during the read operation.
	*/
	function readPages(connection, device, pageOffset, length) {
		if (hasCommand("readPages")) {
			if (pageOffset + length > memoryPages) {
				var remaining = connection.applet.memoryPages - pageOffset
				throw new Error("Cannot read past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset 0x" +
						(pageOffset * pageSize).toString(16) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			var args = [pageOffset, length]
			var status = connection.appletExecute("readPages", args, retries)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to read pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (status: " + status + ")")
			var pagesRead = connection.appletMailboxRead(0)
			if (status !== 9 && pagesRead != length)
				throw new Error("Could not read pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (applet returned success but did not return enough data)");
			var data = connection.appletBufferRead(pagesRead * pageSize)
			if (data.length < pagesRead * pageSize)
				throw new Error("Could not read pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (read from applet buffer failed)")
			return data
		} else if (hasCommand("legacyReadBuffer")) {
			if (pageOffset + length > memoryPages) {
				var remaining = connection.applet.memoryPages - pageOffset
				throw new Error("Cannot read past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset 0x" +
						(pageOffset * pageSize).toString(16) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			var args = [bufferAddr, length * pageSize, pageOffset * pageSize]
			var status = connection.appletExecute("legacyReadBuffer",
			                                      args, retries)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to read pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (status: " + status + ")")
			var pagesRead = connection.appletMailboxRead(0) / pageSize
			if (status !== 9 && pagesRead != length)
				throw new Error("Could not read pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (applet returned success but did not return enough data)")
			var data = connection.appletBufferRead(pagesRead * pageSize)
			if (data.length < pagesRead * pageSize)
				throw new Error("Could not read pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (read from applet buffer failed)")
			return data
		} else {
			throw new Error("Applet supports neither 'Read Pages' nor 'Read Buffer' commands")
		}
	}

	/*!
		\qmlmethod void Applet::canWritePages()
		\brief Check is the applet supports a write command

		Returns a boolean value indicating whether a write command is
		supported.
	*/
	function canWritePages() {
		return hasCommand("writePages") ||
		       hasCommand("legacyWriteBuffer")
	}

	/*!
		\qmlmethod void Applet::writePages(Connection connection, Device device, int pageOffset, ByteArray data)
		\brief Write \a data at \a pageOffset

		The \a data length must be a multiple of the applet page size.

		Returns the number of pages written.

		Throws an \a Error if no write command is supported or if an
		error occurs during the write operation.
	*/
	function writePages(connection, device, pageOffset, data) {
		if (hasCommand("writePages")) {
			if ((data.length & (pageSize - 1)) != 0)
				throw new Error("Invalid write data buffer length " +
						"(must be a multiple of page size)");
			var length = data.length / pageSize
			if (pageOffset + length > memoryPages) {
				var remaining = connection.applet.memoryPages - pageOffset
				throw new Error("Cannot write past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset 0x" +
						(pageOffset * pageSize).toString(16) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			if (!connection.appletBufferWrite(data))
				throw new Error("Could not write pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (write to applet buffer failed)");
			var args = [pageOffset, length]
			var status = connection.appletExecute("writePages", args, retries)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to write pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (status: " + status + ")")
			var pagesWritten = connection.appletMailboxRead(0)
			if (status !== 9 && pagesWritten !== length)
				throw new Error("Could not write pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (applet returned success but did not write enough data)");
			return pagesWritten
		} else if (hasCommand("legacyWriteBuffer")) {
			if ((data.length & (pageSize - 1)) != 0)
				throw new Error("Invalid write data buffer length " +
						"(must be a multiple of page size)")
			var length = data.length / pageSize
			if (pageOffset + length > memoryPages) {
				var remaining = connection.applet.memoryPages - pageOffset
				throw new Error("Cannot write past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset 0x" +
						(pageOffset * pageSize).toString(16) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			if (!connection.appletBufferWrite(data))
				throw new Error("Could not write pages at address 0x"
						+ (pageOffset * pageSize).toString(16)
						+ " (write to applet buffer failed)")
			var args = [bufferAddr, length * pageSize, pageOffset * pageSize]
			var status = connection.appletExecute("legacyWriteBuffer",
			                                      args, retries)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to write pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (status: " + status + ")")
			var pagesWritten = connection.appletMailboxRead(0) / pageSize
			if (status !== 9 && pagesWritten !== length)
				throw new Error("Could not write pages at address 0x" +
						(pageOffset * pageSize).toString(16) +
						" (applet returned success but did not write enough data)")
			return pagesWritten
		} else {
			throw new Error("Applet supports neither 'Write Pages' nor 'Write Buffer' commands")
		}
	}

	/*!
		\qmlmethod void Applet::canSetGPNVM()
		\brief Check is the applet supports the 'set gpvnm' command

		Returns a boolean value indicating if the 'set gpnvm' command
		is supported.
	*/
	function canSetGpnvm() {
		return hasCommand("legacyGpnvm")
	}

	/*!
		\qmlmethod void Applet::setGPNVM(Connection connection, Device device, int index)
		\brief Set the GPNVM at \a index

		Throws an \a Error if the 'clear gpnvm' command is not supported.
	*/
	function setGpnvm(connection, device, index)
	{
		if (hasCommand("legacyGpnvm")) {
			var status = connection.appletExecute("legacyGpnvm",
			                                      [ 1, index ], retries)
			if (status !== 0)
				throw new Error("GPNVM Set command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'GPNVM' command")
		}
	}

	/*!
		\qmlmethod void Applet::canClearGPNVM()
		\brief Check is the applet supports the 'clear gpvnm' command

		Returns a boolean value indicating if the 'clear gpnvm' command
		is supported.
	*/
	function canClearGpnvm() {
		return hasCommand("legacyGpnvm")
	}

	/*!
		\qmlmethod void Applet::clearGPNVM(Connection connection, Device device, int index)
		\brief Clear the GPNVM at \a index

		Throws an \a Error if the 'clear gpnvm' command is not supported.
	*/
	function clearGpnvm(connection, device, index)
	{
		if (hasCommand("legacyGpnvm")) {
			var status = connection.appletExecute("legacyGpnvm",
			                                      [ 0, index ], retries)
			if (status !== 0)
				throw new Error("GPNVM Clear command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'GPNVM' command")
		}
	}
}
