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

/*! \internal */
Applet {
	name: "nandflash"
	description: "NAND Flash"
	codeUrl: Qt.resolvedUrl("applets/applet-nandflash_sam9x35-generic_ddram.bin")
	codeAddr: 0x20000000
	mailboxAddr: 0x20000004
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]
	trimPadding: true

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.nandIoset === "undefined")
			throw new Error("Incomplete configuration, missing value for nandIoset")

		if (typeof device.config.nandBusWidth === "undefined")
			throw new Error("Incomplete configuration, missing value for nandBusWidth")

		if (typeof device.config.nandHeader === "undefined")
			throw new Error("Incomplete configuration, missing value for nandHeader")

		var args = defaultInitArgs(connection, device)
		var config = [ device.config.nandIoset,
		               device.config.nandBusWidth,
		               device.config.nandHeader ]
		Array.prototype.push.apply(args, config)
		return args
	}

	/*! \internal */
	function prependNandHeader(nandHeader, data) {
		// prepare nand header
		var header = Utils.createByteArray(52 * 4)
		for (var i = 0; i < 52; i++)
			header.writeu32(i * 4, nandHeader)
		// prepend header to data
		data.prepend(header)
		print("Prepended NAND header prefix (" +
			  Utils.hex(nandHeader, 8) + ")")
	}

	/*! \internal */
	function prepareBootFile(connection, device, data) {
		patch6thVector(data)
		prependNandHeader(device.config.nandHeader, data)
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
		switch (args.length)
		{
		case 3:
			if (args[2].length > 0) {
				device.config.nandHeader = Number(args[2]);
				if (isNaN(device.config.nandHeader))
					return "Invalid NAND header (not a number)."
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				device.config.nandBusWidth = Number(args[1]);
				if (isNaN(device.config.nandBusWidth))
					return "Invalid NAND bus width (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				device.config.nandIoset = Number(args[0]);
				if (isNaN(device.config.nandIoset))
					return "Invalid NAND ioset (not a number)."
			}
			// fall-through
		case 0:
			return true
		default:
			return "Invalid number of arguments."
		}
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
		        "    nandflash:1:8:0xc0098da5  use fully custom settings (IOSET1, 8-bit bus, header is 0xc0098da5)",
		        "    nandflash:::0xc0098da5    use default board settings but force header to 0xc0098da5",
		        "For information on NAND header values, please refer to SAM9xx5 datasheet section \"10.4.4 Detailed Memory Boot Procedures\"."]
	}
}
