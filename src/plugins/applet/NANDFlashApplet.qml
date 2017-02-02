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
import SAMBA 3.1

/*! \internal */
Applet {
	name: "nandflash"
	description: "NAND Flash"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]
	trimPadding: true

	property string nandHeaderHelp: "For information on NAND header values, please refer to product datasheet."

	/*! \internal */
	function buildInitArgs(connection, device) {
		var config = device.config.nandflash

		if (typeof config.ioset === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'ioset' property")

		if (typeof config.busWidth === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'busWidth' property")

		if (typeof config.header === "undefined")
			throw new Error("Incomplete NAND Flash configuration, missing value for 'header' property")

		var args = defaultInitArgs(connection, device)
		args.push(config.ioset)
		args.push(config.busWidth)
		args.push(config.header)
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
		prependNandHeader(device.config.nandflash.header, data)
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
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
}
