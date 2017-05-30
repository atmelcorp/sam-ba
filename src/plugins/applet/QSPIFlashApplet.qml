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
	name: "qspiflash"
	description: "QSPI Flash"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.qspiflash

		if (typeof config.instance === "undefined")
			throw new Error("Incomplete QSPI Flash configuration, missing value for 'instance' property")

		if (typeof config.ioset === "undefined")
			throw new Error("Incomplete QSPI Flash configuration, missing value for 'ioset' property")

		if (typeof config.freq === "undefined")
			throw new Error("Incomplete QSPI Flash configuration, missing value for 'freq' property")

		var args = defaultInitArgs()
		args.push(config.instance)
		args.push(config.ioset)
		args.push(Math.floor(config.freq * 1000000))
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args)	{
		if (args.length > 3)
			return "Invalid number of arguments."

		var config = device.config.qspiflash

		if (args.length >= 3) {
			if (args[2].length > 0) {
				config.freq = Utils.parseInteger(args[2]);
				if (isNaN(config.freq))
					return "Invalid QSPI frequency (not a number)."
			}
		}

		if (args.length >= 2) {
			if (args[1].length > 0) {
				config.ioset = Utils.parseInteger(args[1]);
				if (isNaN(config.ioset))
					return "Invalid QSPI ioset (not a number)."
			}
		}

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.instance = Utils.parseInteger(args[0]);
				if (isNaN(config.instance))
					return "Invalid QSPI instance (not a number)."
			}
		}

		return true
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: qspiflash:[<instance>]:[<ioset>]:[<frequency>]",
		        "Parameters:",
		        "    instance   QSPI controller instance",
		        "    ioset      QSPI I/O set",
		        "    frequency  QSPI clock frequency in MHz",
		        "Examples:",
		        "    qspiflash         use default board settings",
		        "    qspiflash:0:3:66  use fully custom settings (QSPI0, IOSET3, 66Mhz)",
		        "    qspiflash:::20    use default board settings but force frequency to 20Mhz"]
	}
}
