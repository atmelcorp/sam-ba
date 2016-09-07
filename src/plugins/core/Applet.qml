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
import SAMBA 3.1

/*!
	\qmltype Applet
	\inqmlmodule SAMBA
	\brief Contains a description of a SAM-BA Applet and its runtime variables
*/
AppletBase {
	/*!
		\qmlmethod void Applet::defaultInitArgs(Connection connection, Device device)
		\brief Returns the default input mailbox for applet initialization

		The default mailbox contains the connection type followed by the trace level.
		This method is called by the default buildInitArgs implementation.
	*/
	function defaultInitArgs(connection, device) {
		return [ connection.appletConnectionType, traceLevel ]
	}

	/*!
		\qmlmethod void Applet::buildInitArgs(Connection connection, Device device)
		\brief Returns the input mailbox for applet initialization

		The default implementation just calls defaultInitArgs.
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

	/*! \internal */
	function canInitialize() {
		return hasCommand("initialize") ||
		       hasCommand("legacyInitialize")
	}

	/*! \internal */
	function callInitialize(connection, device) {
		var args, status, cmd

		cmd = command("initialize")
		if (cmd) {
			args = buildInitArgs(connection, device)
			status = connection.appletExecute(cmd, args)
			if (status === 0) {
				bufferAddr = connection.appletMailboxRead(0)
				bufferSize = connection.appletMailboxRead(1)
				pageSize = connection.appletMailboxRead(2)
				memoryPages = connection.appletMailboxRead(3)
				eraseSupport = connection.appletMailboxRead(4)
				nandHeader = connection.appletMailboxRead(5)
			} else {
				memorySize = 0
				bufferAddr = 0
				bufferSize = 0
				pageSize = 0
				eraseSupport = 0
				nandHeader = 0
				throw new Error("Could not initialize applet" +
						" (status: " + status + ")");
			}
		} else {
			cmd = command("legacyInitialize")
			if (cmd) {
				args = buildInitArgs(connection, device)
				if (name === "lowlevel")
					args.push(0, 0, 0)
				status = connection.appletExecute(cmd, args)
				if (status === 0) {
					memorySize = connection.appletMailboxRead(0)
					bufferAddr = connection.appletMailboxRead(1)
					bufferSize = connection.appletMailboxRead(2)
					nandHeader = 0
				} else {
					memorySize = 0
					bufferAddr = 0
					bufferSize = 0
					nandHeader = 0
					throw new Error("Could not initialize applet " +
							name + " (status: " + status + ")")
				}
			} else {
				throw new Error("Applet does not support 'Initialize' command")
			}
		}

		// limit buffer size
		if (bufferSize > 128*1024)
			bufferSize = 128*1024
	}

	/*!
		\qmlmethod void Applet::initialize(Connection connection, Device device)
		\brief Load and initializes the applet.

		Throws an \a Error if the applet could not be loaded or initialized.
	*/
	function initialize(connection, device)
	{
		if (connection.applet !== this) {
			if (!connection.appletUpload(this))
				throw new Error("Applet " + name + " could not be loaded")
		}

		if (canInitialize()) {
			callInitialize(connection, device)
			if (memorySize > 1)
				print("Detected memory size is " + memorySize + " bytes.")
			if (nandHeader !== 0)
				print("NAND header value " + Utils.hex(nandHeader, 8))
		}
	}

	/*! \internal */
	function canEraseAll() {
		return hasCommand("legacyEraseAll")
	}

	/*! \internal */
	function callEraseAll(connection, device) {
		var status, cmd

		cmd = command("legacyEraseAll")
		if (cmd) {
			status = connection.appletExecute(cmd, [])
			if (status !== 0)
				throw new Error("Failed to fully erase device " +
						"(status: " + status + ")")
		} else {
			throw new Error("Applet does not support 'Erase All' command")
		}
	}

	/*!
		\qmlmethod void Applet::eraseAll(Connection connection, Device device)
		\brief Fully Erase the Device

		Completely erase the device using the applet 'full erase'
		command or several applet 'page erase' commands.

		Throws an \a Error if the applet has no Full Erase command or
		if an error occured during erase
	*/
	function eraseAll(connection, device)
	{
		if (canEraseAll()) {
			callEraseAll(connection, device)
		} else if (canErasePages()) {
			erase(connection, device)
		} else {
			throw new Error("Applet '" + name +
		                        "' does not support any erase command")
		}
	}

	/*! \internal */
	function canErasePages() {
		return hasCommand("erasePages")
	}

	/*! \internal */
	function callErasePages(connection, device, pageOffset, length) {
		var args, status

		if (!canErasePages()) {
			throw new Error("Applet does not support 'Erase Pages' command")
		}

		var cmd = command("erasePages")
		if (cmd) {
			args = [ pageOffset, length ]
			status = connection.appletExecute(cmd, args)
			if (status === 0) {
				return connection.appletMailboxRead(0)
			} else if (status === 9) {
				print("Skipped bad pages at offset " +
				      Utils.hex(pageOffset * pageSize, 8));
				return length
			} else {
				throw new Error("Could not erase pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (status: " + status + ")");
			}
		}
	}

	/*!
		\qmlmethod void Applet::erase(Connection connection, Device device, int offset, int size)
		\brief Erases a block of memory.

		Erases \a size bytes at offset \a offset using the applet
		'block erase' command.

		Throws an \a Error if the applet has no block erase command or
		if an error occured during erasing
	*/
	function erase(connection, device, offset, size)
	{
		if (!canErasePages()) {
			throw new Error("Applet '" + name +
			                "' does not support 'erase pages' command")
		}

		// no offset supplied, start at 0
		if (typeof offset === "undefined") {
			offset = 0
		} else {
			if ((offset & (pageSize - 1)) !== 0)
				throw new Error("Offset is not page-aligned")
			offset /= pageSize
		}

		// no size supplied, do a full erase
		if (size === undefined) {
			size = memoryPages - offset
		} else {
			if ((size & (pageSize - 1)) !== 0)
				throw new Error("Size is not page-aligned")
			size /= pageSize
		}

		if ((offset + size) > memoryPages)
			throw new Error("Requested erase region overflows memory")

		var end = offset + size

		var plan = computeErasePlan(offset, end, false)
		if (plan === undefined)
			throw new Error("Cannot erase requested region using supported erase block sizes without overflow")

		for (var i in plan) {
			offset = plan[i].start
			for (var n = 0; n < plan[i].count; n++) {
				var count = callErasePages(connection, device, offset,
									   plan[i].length)
				var percent = 100 * (1 - ((end - offset - count) / size))
				print("Erased " +
				      (count * pageSize) +
				      " bytes at address " +
				      Utils.hex(offset * pageSize, 8) +
				      " (" + percent.toFixed(2) + "%)")
				offset += count
			}
		}
	}

	/*! \internal */
	function canReadPages() {
		return hasCommand("readPages") ||
		       hasCommand("legacyReadBuffer")
	}

	/*! \internal */
	function callReadPages(connection, device, pageOffset, length) {
		var remaining, args, status, pagesRead, data, cmd

		cmd = command("readPages")
		if (cmd) {
			if (pageOffset + length > memoryPages) {
				remaining = memoryPages - pageOffset
				throw new Error("Cannot read past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			args = [ pageOffset, length ]
			status = connection.appletExecute(cmd, args)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to read pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (status: " + status + ")")
			pagesRead = connection.appletMailboxRead(0)
			if (status !== 9 && pagesRead !== length)
				throw new Error("Could not read pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (applet returned success but did not return enough data)");
			data = connection.appletBufferRead(pagesRead * pageSize)
			if (data.length < pagesRead * pageSize)
				throw new Error("Could not read pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (read from applet buffer failed)")
			return data
		}

		cmd = command("legacyReadBuffer")
		if (cmd) {
			if (pageOffset + length > memoryPages) {
				remaining = memoryPages - pageOffset
				throw new Error("Cannot read past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			args = [ bufferAddr, length * pageSize, pageOffset * pageSize ]
			status = connection.appletExecute(cmd, args)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to read pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (status: " + status + ")")
			pagesRead = connection.appletMailboxRead(0) / pageSize
			if (status !== 9 && pagesRead !== length)
				throw new Error("Could not read pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (applet returned success but did not return enough data)")
			data = connection.appletBufferRead(pagesRead * pageSize)
			if (data.length < pagesRead * pageSize)
				throw new Error("Could not read pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (read from applet buffer failed)")
			return data
		}

		throw new Error("Applet supports neither 'Read Pages' nor 'Read Buffer' commands")
	}

	/*!
		\qmlmethod void Applet::read(Connection connection, Device device, int offset, int size, string fileName)
		\brief Read data from the device into a file.

		Reads \a size bytes at offset \a offset using the applet 'read'
		command and writes the data to a file named \a fileName.

		Throws an \a Error if the applet has no read command or if an
		error occured during reading
	*/
	function read(connection, device, offset, size, fileName)
	{
		if (!canReadPages())
			throw new Error("Applet '" + name +
			                "' does not support 'read pages' command")

		if ((offset & (pageSize - 1)) !== 0)
			throw new Error("Read offset is not page-aligned")
		offset /= pageSize

		// TODO handle non-page aligned sizes
		if ((size & (pageSize - 1)) !== 0)
			throw new Error("Read size is not page-aligned")
		size /= pageSize

		var data, percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0) {
			var count = Math.min(remaining, bufferPages)

			var result = callReadPages(connection, device,
									   offset, count)
			if (result.length < count * pageSize)
				count = result.length / pageSize

			if (count === 0) {
				if (badCount === 0)
					badOffset = offset
				badCount++
				offset++
				continue
			} else if (badCount > 0) {
				print("Skipped " + badCount + " bad page(s) at address " +
				      Utils.hex(badOffset * pageSize, 8))
				badCount = 0
			}

			if (!data)
				data = result
			else
				data.append(result)

			percent = 100 * (1 - ((remaining - count) / size))
			print("Read " + (count * pageSize) + " bytes at address " +
			      Utils.hex(offset * pageSize, 8) +
			      " (" + percent.toFixed(2) + "%)")

			offset += count
			remaining -= count
		}

		if (!data.writeFile(fileName))
			throw new Error("Could not write to file '" + fileName + "'")
	}

	/*!
		\qmlmethod void Applet::verify(Connection connection, Device device, int offset, string fileName, bool bootFile)
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
	function verify(connection, device, offset, fileName, bootFile)
	{
		if (!canReadPages())
			throw new Error("Applet '" + name +
			                "' does not support 'read buffer' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read file '" + fileName + "'")
		if (!!bootFile)
			prepareBootFile(connection, device, data)

		if ((offset & (pageSize - 1)) !== 0) {
			throw new Error("Verify offset is not page-aligned")
		}
		offset /= pageSize

		// handle input data padding
		if ((data.length & (pageSize - 1)) !== 0) {
			var pad = pageSize - (data.length & (pageSize - 1))
			data.pad(pad, paddingByte)
			print("Added " + pad + " bytes of padding to align to page size")
		}
		var size = data.length / pageSize

		var current = 0
		var percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0)
		{
			var count = Math.min(remaining, bufferPages)

			var result = callReadPages(connection, device, offset, count)
			if (result.length < count * pageSize)
				count = result.length / pageSize

			if (count === 0) {
				if (badCount === 0)
					badOffset = offset
				badCount++
				offset++
				continue
			} else if (badCount > 0) {
				print("Skipped " + badCount + " bad page(s) at address " +
				      Utils.hex(badOffset * pageSize, 8))
				badCount = 0
			}

			var comp = result.compare(data.mid(current * pageSize, result.length));
			if (comp !== undefined)
				throw new Error("Failed verification. First error at file offset " +
				                Utils.hex(current * pageSize + comp, 8))

			percent = 100 * (1 - ((remaining - count) / size))
			print("Verified " + (count * pageSize) + " bytes at address " +
			      Utils.hex(offset * pageSize, 8) +
			      " (" + percent.toFixed(2) + "%)")

			current += count
			offset += count
			remaining -= count
		}
	}

	/*! \internal */
	function canWritePages() {
		return hasCommand("writePages") ||
		       hasCommand("legacyWriteBuffer")
	}

	/*! \internal */
	function callWritePages(connection, device, pageOffset, data) {
		var length, remaining, args, status, pagesWritten, cmd

		cmd = command("writePages")
		if (cmd) {
			if ((data.length & (pageSize - 1)) != 0)
				throw new Error("Invalid write data buffer length " +
						"(must be a multiple of page size)");
			length = data.length / pageSize
			if (pageOffset + length > memoryPages) {
				remaining = memoryPages - pageOffset
				throw new Error("Cannot write past end of memory, only " +
						(remaining * pageSize) +
						" bytes remaining at offset " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (requested " + (length * pageSize) +
						" bytes)")
			}
			if (!connection.appletBufferWrite(data))
				throw new Error("Could not write pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (write to applet buffer failed)");
			args = [ pageOffset, length ]
			status = connection.appletExecute(cmd, args)
			if (status !== 0 && status !== 9)
				throw new Error("Failed to write pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (status: " + status + ")")
			pagesWritten = connection.appletMailboxRead(0)
			if (status !== 9 && pagesWritten !== length)
				throw new Error("Could not write pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (applet returned success but did not write enough data)");
			return pagesWritten
		} else {
			cmd = command("legacyWriteBuffer")
			if (cmd) {
				if ((data.length & (pageSize - 1)) != 0)
					throw new Error("Invalid write data buffer length " +
							"(must be a multiple of page size)")
				length = data.length / pageSize
				if (pageOffset + length > memoryPages) {
					remaining = memoryPages - pageOffset
					throw new Error("Cannot write past end of memory, only " +
							(remaining * pageSize) +
							" bytes remaining at offset " +
							Utils.hex(pageOffset * pageSize, 8) +
							" (requested " + (length * pageSize) +
							" bytes)")
				}
				if (!connection.appletBufferWrite(data))
					throw new Error("Could not write pages at address "
							+ Utils.hex(pageOffset * pageSize, 8)
							+ " (write to applet buffer failed)")
				args = [ bufferAddr, length * pageSize, pageOffset * pageSize ]
				status = connection.appletExecute(cmd, args)
				if (status !== 0 && status !== 9)
					throw new Error("Failed to write pages at address " +
							Utils.hex(pageOffset * pageSize, 8) +
							" (status: " + status + ")")
				pagesWritten = connection.appletMailboxRead(0) / pageSize
				if (status !== 9 && pagesWritten !== length)
					throw new Error("Could not write pages at address " +
							Utils.hex(pageOffset * pageSize, 8) +
							" (applet returned success but did not write enough data)")
				return pagesWritten
			} else {
				throw new Error("Applet supports neither 'Write Pages' nor 'Write Buffer' commands")
			}
		}
	}

	/*!
		\qmlmethod void Applet::write(Connection connection, Device device, int offset, string fileName, bool bootFile)
		\brief Writes data from a file to the device.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no write command or if an
		error occured during writing
	*/
	function write(connection, device, offset, fileName, bootFile)
	{
		if (!canWritePages())
			throw new Error("Applet '" + name +
			                "' does not support 'buffer write' command")

		var data = Utils.readFile(fileName)
		if (!data)
			throw new Error("Could not read from file '" + fileName + "'")
		if (!!bootFile)
			prepareBootFile(connection, device, data)

		if ((offset & (pageSize - 1)) !== 0)
			throw new Error("Write offset is not page-aligned")
		offset /= pageSize

		// handle input data padding
		if ((data.length & (pageSize - 1)) !== 0) {
			var pad = pageSize - (data.length & (pageSize - 1))
			data.pad(pad, paddingByte)
			print("Added " + pad + " bytes of padding to align to page size")
		}
		var size = data.length / pageSize

		var current = 0
		var percent
		var badOffset, badCount = 0
		var remaining = size
		while (remaining > 0) {
			var pagesToSkip = 0
			var pagesToWrite = remaining

			if (trimPadding) {
				var pagesToEndOfBlock = Math.min(remaining, eraseSupport - (offset & (eraseSupport - 1)))

				// only skip empty pages for full blocks
				if (pagesToEndOfBlock == eraseSupport)
					pagesToSkip = data.getTrimCount(current * pageSize, pagesToEndOfBlock, pageSize, paddingByte)
				pagesToWrite = pagesToEndOfBlock - pagesToSkip
			}

			// write non-empty pages
			while (pagesToWrite > 0) {
				var count = Math.min(pagesToWrite, bufferPages)

				var pagesWritten = callWritePages(connection, device, offset,
						data.mid(current * pageSize, count * pageSize))
				if (pagesWritten < count)
					count = pagesWritten

				if (count === 0) {
					if (badCount === 0)
						badOffset = offset
					badCount++
					offset++
					continue
				} else if (badCount > 0) {
					print("Skipped " + badCount + " bad page(s) at address " +
					      Utils.hex(badOffset * pageSize, 8))
					badCount = 0
				}

				percent = 100 * (1 - ((remaining - count) / size))
				print("Wrote " + (count * pageSize) + " bytes at address " +
				      Utils.hex(offset * pageSize, 8) +
				      " (" + percent.toFixed(2) + "%)")

				current += count
				offset += count
				remaining -= count
				pagesToWrite -= count
			}

			// skip empty pages
			if (pagesToSkip > 0) {
				print("Skipped " + pagesToSkip + " empty page(s) at address " +
				      Utils.hex(offset * pageSize, 8))
				current += pagesToSkip
				offset += pagesToSkip
				remaining -= pagesToSkip
			}
		}
	}

	/*!
		\qmlmethod void Applet::writeVerify(Connection connection, Device device, int offset, string fileName, bool bootFile)
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
	function writeVerify(connection, device, offset, fileName, bootFile)
	{
		write(connection, device, offset, fileName, bootFile)
		verify(connection, device, offset, fileName, bootFile)
	}

	/*! \internal */
	function canSetGpnvm() {
		return hasCommand("legacyGpnvm")
	}

	/*! \internal */
	function callSetGpnvm(connection, device, index)
	{
		var status, cmd

		cmd = command("legacyGpnvm")
		if (cmd) {
			status = connection.appletExecute(cmd, [ 1, index ])
			if (status !== 0)
				throw new Error("GPNVM Set command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'GPNVM' command")
		}
	}

	/*!
		\qmlmethod void Applet::setGpnvm(Connection connection, Device device, int index)
		\brief Sets GPNVM.

		Sets GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during setting GPNVM
	*/
	function setGpnvm(connection, device, index)
	{
		if (!canSetGpnvm())
			throw new Error("Applet '" + name
					+ "' does not support 'Set GPNVM' command")
		callSetGpnvm(connection, device, index)
	}

	/*! \internal */
	function canClearGpnvm() {
		return hasCommand("legacyGpnvm")
	}

	/*! \internal */
	function callClearGpnvm(connection, device, index)
	{
		var status, cmd

		cmd = command("legacyGpnvm")
		if (cmd) {
			status = connection.appletExecute(cmd, [ 0, index ])
			if (status !== 0)
				throw new Error("GPNVM Clear command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'GPNVM' command")
		}
	}

	/*!
		\qmlmethod void Applet::clearGpnvm(Connection connection, Device device, int index)
		\brief Clears GPNVM.

		Clears GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during clearing GPNVM
	*/
	function clearGpnvm(connection, device, index)
	{
		if (!connection.applet.canClearGpnvm())
			throw new Error("Applet '" + name
					+ "' does not support 'Clear GPNVM' command")
		callClearGpnvm(connection, device, index)
	}

	/*! \internal */
	function callReadBootCfg(connection, device, index)
	{
		var status, cmd

		cmd = command("readBootCfg")
		if (cmd) {
			status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Read Boot Config command failed (status=" +
						status + ")")
			return connection.appletMailboxRead(0);
		} else {
			throw new Error("Applet does not support 'Read Boot Config' command")
		}
	}

	/*!
		\qmlmethod int Applet::readBootCfg(Connection connection, Device device, int index)
		\brief Read the boot configuration

		Read and returns the boot configuration at index \a index using the applet
		'Read Boot Config' command.

		Throws an \a Error if the applet has no 'Read Boot Config' command or
		if an error occured during calling the applet command
	*/
	function readBootCfg(connection, device, index)
	{
		return callReadBootCfg(connection, device, index)
	}

	/*! \internal */
	function callWriteBootCfg(connection, device, index, value)
	{
		var status, cmd

		cmd = command("writeBootCfg")
		if (cmd) {
			status = connection.appletExecute(cmd, [index, value])
			if (status !== 0)
				throw new Error("Write Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Write Boot Config' command")
		}
	}

	/*!
		\qmlmethod void Applet::writeBootCfg(Connection connection, Device device, int index, int value)
		\brief Write the boot configuration

		Write the boot configuration \a value at index \a index using the
		applet 'Write Boot Config' command.

		Throws an \a Error if the applet has no 'Write Boot Config' command or
		if an error occured during calling the applet command
	*/
	function writeBootCfg(connection, device, index, value)
	{
		callWriteBootCfg(connection, device, index, value)
	}

	/*! \internal */
	function computeErasePlan(start, end, overflow) {
		var supported = []
		var i, size

		for (i = 32; i >= 0; i--) {
			size = 1 << i
			if ((eraseSupport & size) !== 0)
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

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args) {
		if (args.length > 0)
			return "Invalid number of arguments."
	}

	/*! \internal */
	function commandLineHelp() {
		return ["No arguments supported for " + name + " applet."]
	}

	/*! \internal */
	function defaultCommandLineCommands() {
		var commands = []
		if (canEraseAll())
			commands.push("fullerase");
		if (canErasePages())
			commands.push("erase");
		if (canReadPages()) {
			commands.push("read");
			commands.push("verify");
			commands.push("verifyboot");
		}
		if (canWritePages()) {
			commands.push("write");
			commands.push("writeboot");
		}
		return commands
	}

	/*! \internal */
	function commandLineCommands() {
		return defaultCommandLineCommands()
	}

	/*! \internal */
	function defaultCommandLineCommandHelp(command) {
		if (command === "fullerase") {
			return ["* fullerase - erase all the memory",
			        "Syntax:",
			        "    fullerase"]
		}
		else if (command === "erase") {
			return ["* erase - erase all or part of the memory",
			        "Syntax:",
			        "    erase:[<addr>]:[<length>]",
			        "Examples:",
			        "    erase                 erase all",
			        "    erase:4096            erase from 4096 to end",
			        "    erase:0x1000:0x10000  erase from 0x1000 to 0x11000",
			        "    erase::0x1000         erase from 0 to 0x1000"]
		}
		else if (command === "read") {
			return ["* read - read from memory to a file",
			        "Syntax:",
			        "    read:<filename>:[<addr>]:[<length>]",
			        "Examples:",
			        "    read:firmware.bin              read all to firmware.bin",
			        "    read:firmware.bin:0x1000       read from 0x1000 to end into firmware.bin",
			        "    read:firmware.bin:0x1000:1024  read 1024 bytes from 0x1000 into firmware.bin",
			        "    read:firmware.bin::1024        read 1024 bytes from start of memory into firmware.bin"]
		}
		else if (command === "write") {
			return ["* write - write to memory from a file",
			        "Syntax:",
			        "    write:<filename>:[<addr>]",
			        "Examples:",
			        "    write:firmware.bin         write firmware.bin to start of memory",
			        "    write:firmware.bin:0x1000  write firmware.bin at offset 0x1000"]
		}
		else if (command === "writeboot") {
			return ["* writeboot - write boot program to memory from a file",
			        "Syntax:",
			        "    writeboot:<filename>",
			        "Example:",
			        "    writeboot:firmware.bin  write firmware.bin as boot program at start of memory"]
		}
		else if (command === "verify") {
			return ["* verify - verify memory from a file",
			        "Syntax:",
			        "    verify:<filename>:[<addr>]",
			        "Examples:",
			        "    verify:firmware.bin         verify that start of memory matches firmware.bin",
			        "    verify:firmware.bin:0x1000  verify that memory at offset 0x1000 matches firmware.bin"]
		}
		else if (command === "verifyboot") {
			return ["* verifyboot - verify boot program from a file",
			        "Syntax:",
			        "    verifyboot:<filename>",
			        "Example:",
			        "    verify:firmware.bin  verify that start of memory matches boot program firmware.bin"]
		}
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		return defaultCommandLineCommandHelp(command)
	}

	/*! \internal */
	function commandLineCommandFullErase(connection, device, args) {
		var addr, length

		if (args.length != 0)
			return "Invalid number of arguments (expected 0)."

		try {
			eraseAll(connection, device)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandErase(connection, device, args) {
		var addr, length

		switch (args.length) {
		case 2:
			if (args[1].length !== 0) {
				length = Utils.parseInteger(args[1])
				if (isNaN(length))
					return "Invalid length parameter (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length !== 0) {
				addr = Utils.parseInteger(args[0])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
			// fall-through
		case 0:
			break;
		default:
			return "Invalid number of arguments (expected 0, 1 or 2)."
		}

		if (typeof addr === "undefined")
			addr = 0
		if (typeof length === "undefined")
			length = memorySize - addr

		try {
			erase(connection, device, addr, length)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandRead(connection, device, args) {
		var filename, addr, length

		if (args.length < 1)
			return "Invalid number of arguments (expected at least 1)."
		if (args.length > 3)
			return "Invalid number of arguments (expected at most 3)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		if (args.length > 1) {
			// address (optional)
			if (args[1].length !== 0) {
				addr = Utils.parseInteger(args[1])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
		}

		if (args.length > 2) {
			// length (optional)
			if (args[2].length !== 0) {
				length = Utils.parseInteger(args[2])
				if (isNaN(length))
					return "Invalid length parameter (not a number)."
			}
		}

		if (typeof addr === "undefined")
			addr = 0
		if (typeof length === "undefined")
			length = memorySize - addr

		try {
			read(connection, device, addr, length, filename)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandWriteVerify(connection, device, args, shouldWrite) {
		var addr, length, filename

		if (args.length < 1)
			return "Invalid number of arguments (expected at least 1)."
		if (args.length > 2)
			return "Invalid number of arguments (expected at most 2)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		// address (optional)
		if (args.length > 1) {
			if (args[1].length !== 0) {
				addr = Utils.parseInteger(args[1])
				if (isNaN(addr))
					return "Invalid address parameter (not a number)."
			}
		}

		if (typeof addr === "undefined")
			addr = 0

		try {
			if (shouldWrite)
				write(connection, device, addr, filename, false)
			else
				verify(connection, device, addr, filename, false)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandWriteVerifyBoot(connection, device, args, shouldWrite) {
		var addr, length, filename

		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		try {
			if (shouldWrite)
				write(connection, device, 0, filename, true)
			else
				verify(connection, device, 0, filename, true)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function defaultCommandLineCommand(connection, device, command, args) {
		if (command === "fullerase" && canEraseAll()) {
			return commandLineCommandFullErase(connection, device, args)
		}
		else if (command === "erase" && canErasePages()) {
			return commandLineCommandErase(connection, device, args)
		}
		else if (command === "read" && canReadPages()) {
			return commandLineCommandRead(connection, device, args)
		}
		else if (command === "write" && canWritePages()) {
			return commandLineCommandWriteVerify(connection, device,
			                                     args, true)
		}
		else if (command === "writeboot" && canWritePages()) {
			return commandLineCommandWriteVerifyBoot(connection, device,
			                                         args, true)
		}
		else if (command === "verify" && canReadPages()) {
			return commandLineCommandWriteVerify(connection, device,
			                                     args, false)
		}
		else if (command === "verifyboot" && canReadPages()) {
			return commandLineCommandWriteVerifyBoot(connection, device,
			                                         args, false)
		}
		else {
			return "Unknown command."
		}
	}

	/*! \internal */
	function commandLineCommand(connection, device, command, args) {
		return defaultCommandLineCommand(connection, device,
		                                 command, args)
	}
}
