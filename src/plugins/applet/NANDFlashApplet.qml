/*
 * Copyright (c) 2015-2017, Atmel Corporation.
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

/*! \internal */
Applet {
	name: "nandflash"
	description: "NAND Flash"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 },
		AppletCommand { name:"tagBlocks"; code:0x36 }
	]
	trimPadding: true

	property string nandHeaderHelp: "For information on NAND header values, please refer to product datasheet."

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.nandflash

		if (typeof config.ioset === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'ioset' property")

		if (typeof config.busWidth === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'busWidth' property")

		if (typeof config.header === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'header' property")

		var args = defaultInitArgs()
		args.push(config.ioset)
		args.push(config.busWidth)
		args.push(config.header)
		return args
	}

	/*! \internal */
	function prepareBootFile(file) {
		file.enable6thVectorPatching(true)

		// prepare nand header
		var header = new ArrayBuffer(52 * 4)
		var headerView = new DataView(header)
		for (var i = 0; i < 52; i++)
			headerView.setUint32(i * 4, nandHeader, true)

		// prepend header to file data
		file.setHeader(header)
		print("Prepended NAND header prefix (" +
			  Utils.hex(nandHeader, 8) + ")")
	}

	/*! \internal */
	function tag(addr, length, bad) {
		var blockSize = eraseSupport * pageSize

		// no address supplied, start at 0
		if (typeof addr === "undefined") {
			addr = 0
		} else {
			if ((addr & blockSize - 1) !== 0)
				throw new Error("Address is not block-aligned")
			addr /= pageSize
		}

		// no length supplied, tag all memory blocks
		if (typeof length === "undefined") {
			length = memoryPages - addr
		} else {
			if ((length & blockSize - 1) !== 0)
				throw new Error("Length is not block-aligned")
			length /= pageSize
		}

		if ((addr + length) > memoryPages)
			throw new Error("Requested tag region overflows memory")

		var end = addr + length

		var cmd = command("tagBlocks")
		for (var offset = addr; offset < end; offset += eraseSupport) {
			var args = [ offset, (bad ? 1 : 0) ]
			var status = connection.appletExecute(cmd, args)
			if (status === 9) {
				print("Skipped bad block at address " +
					Utils.hex(offset * pageSize, 8))
			} else if (status !== 0) {
				throw new Error("Could not " + (bad ? "" : "un") + "tag block at address " +
						Utils.hex(offset * pageSize, 8) +
						" (status: " + status + ")")
			}
		}
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args)	{
		if (args.length > 3)
			return "Invalid number of arguments."

		var config = device.config.nandflash

		if (args.length >= 3) {
			if (args[2].length > 0) {
				config.header = Utils.parseInteger(args[2]);
				if (isNaN(config.header))
					return "Invalid NAND header (not a number)."
			}
		}

		if (args.length >= 2) {
			if (args[1].length > 0) {
				config.busWidth = Utils.parseInteger(args[1]);
				if (isNaN(config.busWidth))
					return "Invalid NAND bus width (not a number)."
			}
		}

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.ioset = Utils.parseInteger(args[0]);
				if (isNaN(config.ioset))
					return "Invalid NAND ioset (not a number)."
			}
		}

		return true
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: nandflash:[<ioset>]:[<bus_width>]:[<header>]",
		        "Parameters:",
		        "    ioset      I/O set",
		        "    bus_width  NAND bus width (8/16)",
		        "    header     NAND header value",
		        "Examples:",
		        "    nandflash                 use default board settings",
		        "    nandflash:2:8:0xc0098da5  use fully custom settings (IOSET2, 8-bit bus, header is 0xc0098da5)",
		        "    nandflash:::0xc0098da5    use default board settings but force header to 0xc0098da5",
		        nandHeaderHelp]
	}

	/*! \internal */
	function commandLineCommands() {
		 var commands = defaultCommandLineCommands()
		 commands.push("tag")
		 commands.push("untag")
		 return commands
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "tag") {
			return ["* tag - add the 'bad' mark to NAND flash blocks",
			        "Syntax:",
			        "    tag:[<addr>]:[<length>]",
			        "Examples:",
			        "    tag                  tag all memory blocks as bad",
			        "    tag:0x20000          tag from 0x20000 to end",
			        "    tag:0x40000:0x20000  tag from 0x40000 to 0x60000",
			        "    tag::0x80000         tag from 0 to 0x0x80000 "]
		}
		else if (command === "untag") {
			return ["* untag - remove the 'bad' mark to NAND flash blocks",
			        "Syntax:",
			        "    tag:[<addr>]:[<length>]",
			        "Examples:",
			        "    untag                  untag all memory blocks as bad",
			        "    untag:0x20000          untag from 0x20000 to end",
			        "    untag:0x40000:0x20000  untag from 0x40000 to 0x60000",
			        "    untag::0x80000         untag from 0 to 0x0x80000 "]
		}
		else {
			return defaultCommandLineCommandHelp(command)
		}
	}

	/*! \internal */
	function commandLineCommandTag(args, bad) {
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

		try {
			tag(addr, length, bad)
		} catch(err) {
			return err.message
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "tag") {
			return commandLineCommandTag(args, true)
		}
		if (command === "untag") {
			return commandLineCommandTag(args, false)
		}
		else {
			return defaultCommandLineCommand(command, args)
		}
	}
}
