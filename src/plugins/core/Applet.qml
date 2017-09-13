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
import SAMBA 3.2

/*!
	\qmltype Applet
	\inqmlmodule SAMBA
	\brief Contains a description of a SAM-BA Applet and its runtime variables
*/
Item {
	/*!
		\qmlproperty string Applet::name
		\brief The applet name
	*/
	property var name

	/*!
		\qmlproperty string Applet::description
		\brief The applet description
	*/
	property var description

	/*!
		\qmlproperty Device Applet::device
		\brief The parent device for this applet
	*/
	property var device

	/*!
		\qmlproperty Device Applet::connection
		\brief the currently selected connection
	*/
	property var connection

	/*!
		\qmlproperty string Applet::codeUrl
		\brief The applet binary file URL
	*/
	property var codeUrl

	/*!
		\qmlproperty string Applet::codeAddr
		\brief The applet loading address
	*/
	property var codeAddr

	/*!
		\qmlproperty string Applet::mailboxAddr
		\brief The address at which the applet mailbox is located
	*/
	property var mailboxAddr

	/*!
		\qmlproperty string Applet::entryAddr
		\brief The address of the applet entry point
	*/
	property var entryAddr

	/*!
		\qmlproperty string Applet::bufferAddr
		\brief The address at which the applet buffer is located
	*/
	property var bufferAddr: 0

	/*!
		\qmlproperty string Applet::bufferSize
		\brief The size of the applet buffer in bytes
	*/
	property var bufferSize: 0

	/*!
		\qmlproperty string Applet::bufferPages
		\brief The size of the applet buffer in pages
	*/
	property var bufferPages: bufferSize / pageSize

	/*!
		\qmlproperty string Applet::pageSize
		\brief The size of a page in bytes
	*/
	property var pageSize: 0

	/*!
		\qmlproperty string Applet::memoryPages
		\brief The total memory size in pages
	*/
	property var memoryPages: 0

	/*!
		\qmlproperty string Applet::memorySize
		\brief The total memory size in bytes
	*/
	property var memorySize: memoryPages * pageSize

	/*!
		\qmlproperty string Applet::eraseSupport
		\brief The supported memory erase sizes in pages
		This property contains a bitfield of the supported erase sizes. For
		example a memory with 512-bytes pages that supports 4KB (8 pages) and
		32KB (64 pages) will report an erase support value of 72.
	*/
	property var eraseSupport: 0

	/*!
		\qmlproperty string Applet::paddingByte
		\brief The byte value that will be used to pad data when writing data
		that is not a round number of pages. Default is 0xff.
	*/
	property var paddingByte: 0xff

	/*!
		\qmlproperty string Applet::trimPadding
		\brief If true, empty pages at end of an erase block will not be written.
		This feature is used for NAND memories and will only work if only one
		erase block size is supported.
	*/
	property var trimPadding: false

	/*!
		\qmlproperty string Applet::nandHeader
		\brief Header value that will be added before the program code.
		Required by ROM-code to boot from NAND memory.
	*/
	property var nandHeader: 0

	/*!
		\qmlproperty list<AppletCommand> Applet::commands
		\brief List of all supported commands for this applet
	*/
	property list<AppletCommand> commands

	/*!
		\qmlmethod bool Applet::hasCommand(string name)
		\brief Checks if a given command is supported by the applet.
	*/
	function hasCommand(name) {
		return typeof command(name) != "undefined"
	}

	/*!
		\qmlmethod AppletCommand Applet::command(string name)
		\brief Retrieve a command from the list of supported commands. If the
		command name is not found, returns \a undefined.
	*/
	function command(name) {
		for (var i = 0; i < commands.length; i++)
			if (commands[i].name === name)
				return commands[i]
		return
	}

	/*!
		\qmlmethod void Applet::defaultInitArgs()
		\brief Returns the default input mailbox for applet initialization

		The default mailbox contains the connection type followed by the trace level.
		This method is called by the default buildInitArgs implementation.
	*/
	function defaultInitArgs() {
		var serial_instance = device.config.serial.instance
		var serial_ioset = device.config.serial.ioset
                if (typeof serial_instance === "undefined" ||
		    typeof serial_ioset === "undefined") {
			serial_instance = serial_ioset = 0xffffffff
		}
		return [ connection.appletConnectionType, Script.traceLevel,
		         serial_instance, serial_ioset ]
	}

	/*!
		\qmlmethod void Applet::buildInitArgs()
		\brief Returns the input mailbox for applet initialization

		The default implementation just calls defaultInitArgs.
		It is intended to be overridden by Applet
		sub-classes/instances.
	*/
	function buildInitArgs() {
		return defaultInitArgs()
	}

	/*!
		\qmlmethod void Applet::prepareBootFile(File file)
		\brief Prepare a application file for use as a boot file

		The default implementation enables on-the-fly patching of 6th vector.
		It is intended to be overridden by Applet sub-classes/instances.
	*/
	function prepareBootFile(file) {
		file.enable6thVectorPatching(true)
	}

	/*! \internal */
	function canInitialize() {
		return hasCommand("initialize")
	}

	/*! \internal */
	function callInitialize() {
		var args, status, cmd

		cmd = command("initialize")
		if (cmd) {
			args = buildInitArgs()
			status = connection.appletExecute(cmd, args)
			if (status === 0) {
				bufferAddr = connection.appletMailboxRead(0)
				bufferSize = connection.appletMailboxRead(1)
				pageSize = connection.appletMailboxRead(2)
				memoryPages = connection.appletMailboxRead(3)
				eraseSupport = connection.appletMailboxRead(4)
				nandHeader = connection.appletMailboxRead(5)
			} else {
				bufferAddr = 0
				bufferSize = 0
				pageSize = 0
				memoryPages = 0
				eraseSupport = 0
				nandHeader = 0
				throw new Error("Could not initialize applet" +
						" (status: " + status + ")")
			}
		}

		// limit buffer size
		if (bufferSize > 128*1024)
			bufferSize = 128*1024
	}

	/*!
		\qmlmethod void Applet::initialize()
		\brief Load and initializes the applet.

		Throws an \a Error if the applet could not be loaded or initialized.
	*/
	function initialize()
	{
		if (canInitialize()) {
			callInitialize()
			if (memorySize > 0)
				print("Detected memory size is " + memorySize + " bytes.")
			if (pageSize > 0)
				print("Page size is " + pageSize + " bytes.")
			if (bufferSize > 0)
				print("Buffer is " + bufferSize + " bytes (" + bufferPages + " pages) at address " +
				      Utils.hex(bufferAddr, 8) + ".")
			if (nandHeader !== 0)
				print("NAND header value is " + Utils.hex(nandHeader, 8) + ".")
			if (eraseSupport != 0) {
				var i, size
				var eraseSizes = []
				for (i = 0; i < 32; i++) {
					if ((eraseSupport & (1 << i)) !== 0) {
						size = (1 << i) * pageSize
						if (size > 1024*1024)
							eraseSizes.push("" + (size >> 20) + "MB")
						else if (size > 1024)
							eraseSizes.push("" + (size >> 10) + "KB")
						else
							eraseSizes.push("" + size + "B")
					}
				}
				print("Supported erase block sizes: " + eraseSizes.join(", "))
			}
		}
	}

	/*! \internal */
	function canErasePages() {
		return hasCommand("erasePages")
	}

	/*! \internal */
	function callErasePages(pageOffset, length) {
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
				      Utils.hex(pageOffset * pageSize, 8))
				return length
			} else {
				throw new Error("Could not erase pages at address " +
						Utils.hex(pageOffset * pageSize, 8) +
						" (status: " + status + ")")
			}
		}
	}

	/*!
		\qmlmethod void Applet::erase(int offset, int size)
		\brief Erases a block of memory.

		Erases \a size bytes at offset \a offset using the applet
		'block erase' command.

		Throws an \a Error if the applet has no block erase command or
		if an error occured during erasing
	*/
	function erase(offset, size)
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
				var count = callErasePages(offset, plan[i].length)
				var percent = 100 * (1 - ((end - offset - count) / size))
				print("Erased " + (count * pageSize) + " bytes at address " +
				      Utils.hex(offset * pageSize, 8) + " (" + percent.toFixed(2) + "%)")
				offset += count
			}
		}
	}

	/*! \internal */
	function canReadPages() {
		return hasCommand("readPages")
	}

	/*! \internal */
	function callReadPages(pageOffset, length) {
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
						+ " (applet returned success but did not return enough data)")
			data = connection.appletBufferRead(pagesRead * pageSize)
			if (data.byteLength < pagesRead * pageSize)
				throw new Error("Could not read pages at address "
						+ Utils.hex(pageOffset * pageSize, 8)
						+ " (read from applet buffer failed)")
			return data
		}

		throw new Error("Applet does not support 'Read Pages' commands")
	}

	/*!
		\qmlmethod void Applet::read(int offset, int size, string fileName)
		\brief Read data from the device into a file.

		Reads \a size bytes at offset \a offset using the applet 'read'
		command and writes the data to a file named \a fileName.

		Throws an \a Error if the applet has no read command or if an
		error occured during reading
	*/
	function read(offset, size, fileName)
	{
		if (!canReadPages())
			throw new Error("Applet '" + name +
			                "' does not support 'read pages' command")

		var file = File.open(fileName, true)
		if (!file)
			throw new Error("Could not write file '" + fileName + "'")

		try {
			var badPageTotal = 0
			var badPageFirst
			var badPageCount = 0
			var remaining = size
			while (remaining > 0) {
				/* compute first and last page for the current offset and remaining bytes to read */
				var firstPage = Math.floor(offset / pageSize)
				var lastPage = Math.ceil((offset + remaining) / pageSize)

				/* read as much as the buffer can fit, and at least one page */
				var count = Math.max(1, Math.min(lastPage - firstPage, bufferPages))

				/* read pages from the applet */
				var result = callReadPages(badPageTotal + firstPage, count)
				if (result.byteLength < count * pageSize)
					count = result.byteLength / pageSize

				/* if applet returned 0 pages read, it means that at least one page was faulty. */
				/* skip it and continue */
				/* TODO: only do this for NAND! */
				if (count === 0) {
					if (badPageCount === 0)
						badPageFirst = firstPage
					badPageCount++
					badPageTotal++
					continue
				} else if (badPageCount > 0) {
					print("Skipped " + badPageCount + " bad page(s) at address " +
					      Utils.hex(badPageFirst * pageSize, 8))
					badPageCount = 0
				}

				if (count !== 0) {
					/* compute offset and length of data */
					var readOffset = offset - firstPage * pageSize
					var readLength = Math.min(remaining, count * pageSize - readOffset)

					/* write data to output file */
					var written = file.write(result.slice(readOffset, readOffset + readLength))
					if (written != readLength)
						throw new Error("Could not write to file '" + fileName + "'")

					/* update progression percentage and display it */
					var percent = 100 * (1 - ((remaining - readLength) / size))
					print("Read " + readLength + " bytes at address " +
					      Utils.hex(offset, 8) + " (" + percent.toFixed(2) + "%)")

					/* finally, update the offset and remaining bytes counters */
					offset += readLength
					remaining -= readLength
				}
			}
		}
		finally {
			file.close()
		}
	}

	/*! \internal */
	function prepareForWrite(offset, file, bootFile)
	{
		file.setPaddingByte(paddingByte)

		// patch data and/or add header as required for booting from ROM-code
		if (!!bootFile)
			prepareBootFile(file)

		// adjust offset and add padding before data if required
		if ((offset & (pageSize - 1)) !== 0) {
			var paddingBefore = offset & (pageSize - 1)

			print("Offset " + Utils.hex(offset, 8) + " not paged-aligned: adding " +
			      paddingBefore + " byte(s) of padding and adjusting offset to " +
			      Utils.hex(offset - paddingBefore, 8))

			file.setPaddingBefore(paddingBefore)
			offset -= paddingBefore
		}

		// add padding after data if required
		if ((file.size() & (pageSize - 1)) !== 0) {
			var paddingAfter = pageSize - (file.size() & (pageSize - 1))

			print("Appending " + paddingAfter + " bytes of padding to fill the last written page")

			file.setPaddingAfter(paddingAfter)
		}

		return offset
	}

	/*!
		\qmlmethod void Applet::verify(int offset, string fileName, bool bootFile)
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
	function verify(offset, fileName, bootFile)
	{
		if (!canReadPages())
			throw new Error("Applet '" + name +
			                "' does not support 'read buffer' command")

		var file = File.open(fileName, false)
		if (!file)
			throw new Error("Could not read file '" + fileName + "'")

		offset = prepareForWrite(offset, file, bootFile)
		offset /= pageSize

		var badPageTotal = 0
		var badPageFirst
		var badPageCount = 0
		var size = file.size() / pageSize
		var remaining = size
		var startOffset = offset
		while (remaining > 0) {
			var count = Math.min(remaining, bufferPages)

			var result = callReadPages(badPageTotal + offset, count)
			if (result.byteLength < count * pageSize)
				count = result.byteLength / pageSize

			if (count === 0) {
				if (badPageCount === 0)
					badPageFirst = offset
				badPageCount++
				badPageTotal++
				continue
			} else if (badPageCount > 0) {
				print("Skipped " + badPageCount + " bad page(s) at address " +
				      Utils.hex(badPageFirst * pageSize, 8))
				badPageCount = 0
			}

			file.seek((offset - startOffset) * pageSize)
			var data = file.read(count * pageSize)

			var comp = Utils.compareBuffers(result, data)
			if (comp !== undefined)
				throw new Error("Failed verification. First error at offset " +
				                Utils.hex(offset * pageSize + comp, 8))

			var percent = 100 * (1 - ((remaining - count) / size))
			print("Verified " + (count * pageSize) + " bytes at address " +
			      Utils.hex(offset * pageSize, 8) +
			      " (" + percent.toFixed(2) + "%)")

			offset += count
			remaining -= count
		}
	}

	/*! \internal */
	function canWritePages() {
		return hasCommand("writePages")
	}

	/*! \internal */
	function callWritePages(pageOffset, data) {
		var length, remaining, args, status, pagesWritten, cmd

		cmd = command("writePages")
		if (cmd) {
			if ((data.byteLength & (pageSize - 1)) != 0)
				throw new Error("Invalid write data buffer length " +
						"(must be a multiple of page size)")
			length = data.byteLength / pageSize
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
						" (applet returned success but did not write enough data)")
			return pagesWritten
		} else {
			throw new Error("Applet does not support 'Write Pages' commands")
		}
	}

	/*!
		\qmlmethod void Applet::write(int offset, string fileName, bool bootFile)
		\brief Writes data from a file to the device.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command.

		If \a bootFile is \tt true, file data will be modified to be
		suitable for booting, as required by the device ROM-code.

		Throws an \a Error if the applet has no write command or if an
		error occured during writing or verifying.
	*/
	function write(offset, fileName, bootFile)
	{
		if (!canWritePages())
			throw new Error("Applet '" + name +
			                "' does not support 'buffer write' command")

		var file = File.open(fileName, false)
		if (!file)
			throw new Error("Could not read from file '" + fileName + "'")

		// prepare file file for writing, adjust offset if needed
		offset = prepareForWrite(offset, file, bootFile)
		offset /= pageSize

		try {
			var size = file.size() / pageSize

			var current = 0
			var percent
			var badOffset, badCount = 0
			var remaining = size
			while (remaining > 0) {
				var pagesToSkip
				var pagesToWrite
				var data

				file.seek(current * pageSize)
				if (trimPadding) {
					var pagesToEndOfBlock = Math.min(remaining, eraseSupport - (offset & (eraseSupport - 1)))
					data = file.read(pagesToEndOfBlock * pageSize)
					// only skip empty pages for full blocks
					if (pagesToEndOfBlock == eraseSupport)
						pagesToSkip = Utils.getBufferTrimCount(data, 0, pagesToEndOfBlock, pageSize, paddingByte)
					else
						pagesToSkip = 0
					pagesToWrite = pagesToEndOfBlock - pagesToSkip
				} else {
					pagesToSkip = 0
					pagesToWrite = Math.min(remaining, bufferPages)
					data = file.read(pagesToWrite * pageSize)
				}

				// write non-empty pages
				while (pagesToWrite > 0) {
					var count = Math.min(pagesToWrite, bufferPages)

					var pagesWritten = callWritePages(offset, data.slice(0, count * pageSize))
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

					data = data.slice(count * pageSize)
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
		finally {
			file.close()
		}
	}

	/*!
		\qmlmethod void Applet::writeVerify(int offset, string fileName, bool bootFile)
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
	function writeVerify(offset, fileName, bootFile)
	{
		write(offset, fileName, bootFile)
		verify(offset, fileName, bootFile)
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
	function commandLineParse(args) {
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
		if (canErasePages())
			commands.push("erase")
		if (canReadPages()) {
			commands.push("read")
			commands.push("verify")
			commands.push("verifyboot")
		}
		if (canWritePages()) {
			commands.push("write")
			commands.push("writeboot")
		}
		return commands
	}

	/*! \internal */
	function commandLineCommands() {
		return defaultCommandLineCommands()
	}

	/*! \internal */
	function defaultCommandLineCommandHelp(command) {
		if (command === "erase") {
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
	function commandLineCommandErase(args) {
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
			break
		default:
			return "Invalid number of arguments (expected 0, 1 or 2)."
		}

		if (typeof addr === "undefined")
			addr = 0
		if (typeof length === "undefined")
			length = memorySize - addr

		try {
			erase(addr, length)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandRead(args) {
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
			read(addr, length, filename)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandWriteVerify(args, shouldWrite) {
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
				write(addr, filename, false)
			else
				verify(addr, filename, false)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommandWriteVerifyBoot(args, shouldWrite) {
		var addr, length, filename

		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		// filename (required)
		if (args[0].length === 0)
			return "Invalid file name parameter (empty)"
		filename = args[0]

		try {
			if (shouldWrite)
				write(0, filename, true)
			else
				verify(0, filename, true)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function defaultCommandLineCommand(command, args) {
		if (command === "erase" && canErasePages()) {
			return commandLineCommandErase(args)
		}
		else if (command === "read" && canReadPages()) {
			return commandLineCommandRead(args)
		}
		else if (command === "write" && canWritePages()) {
			return commandLineCommandWriteVerify(args, true)
		}
		else if (command === "writeboot" && canWritePages()) {
			return commandLineCommandWriteVerifyBoot(args, true)
		}
		else if (command === "verify" && canReadPages()) {
			return commandLineCommandWriteVerify(args, false)
		}
		else if (command === "verifyboot" && canReadPages()) {
			return commandLineCommandWriteVerifyBoot(args, false)
		}
		else {
			return "Unknown command."
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		return defaultCommandLineCommand(command, args)
	}
}
