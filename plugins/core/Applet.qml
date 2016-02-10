import QtQuick 2.3
import SAMBA 3.0

/*!
	\qmltype Applet
	\inqmlmodule SAMBA
	\brief TODO
*/
AbstractApplet {
	function defaultInitArgs(connection, device) {
		return [connection.appletConnectionType(), traceLevel]
	}

	function buildInitArgs(connection, device) {
		return defaultInitArgs(connection, device)
	}

	function patch6thVector(data) {
		// write size into 6th vector
		data.writeu32(20, data.length)
		print("Patched file length (" + data.length + ") at offset 20")
	}

	function prepareBootFile(connection, device, data) {
		patch6thVector(data)
	}

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

	function canEraseAll() {
		return hasCommand("legacyEraseAll")
	}

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

	function canErasePages() {
		return hasCommand("erasePages")
	}

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

	function canReadPages() {
		return hasCommand("readPages") ||
		       hasCommand("legacyReadBuffer")
	}

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

	function canWritePages() {
		return hasCommand("writePages") ||
		       hasCommand("legacyWriteBuffer")
	}

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

	function canSetGpnvm() {
		return hasCommand("legacyGpnvm")
	}

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

	function canClearGpnvm() {
		return hasCommand("legacyGpnvm")
	}

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
