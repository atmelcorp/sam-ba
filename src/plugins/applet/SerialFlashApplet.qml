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
	name: "serialflash"
	description: "AT25/AT26 Serial Flash"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]

	/*! \internal */
	function buildInitArgs() {
		var config = device.config.serialflash

		if (typeof config.instance === "undefined")
			throw new Error("Incomplete configuration, missing value for spiInstance")

		if (typeof config.ioset === "undefined")
			throw new Error("Incomplete configuration, missing value for spiIoset")

		if (typeof config.chipSelect === "undefined")
			throw new Error("Incomplete configuration, missing value for spiChipSelect")

		if (typeof config.freq === "undefined")
			throw new Error("Incomplete configuration, missing value for spiFreq")

		var args = defaultInitArgs()
		args.push(config.instance)
		args.push(config.ioset)
		args.push(config.chipSelect)
		args.push(Math.floor(config.freq * 1000000))
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args)	{
		if (args.length > 4)
			return "Invalid number of arguments."

		var config = device.config.serialflash

		if (args.length >= 4) {
			if (args[3].length > 0) {
				config.freq = Utils.parseInteger(args[3]);
				if (isNaN(config.freq))
					return "Invalid SPI frequency (not a number)."
			}
		}

		if (args.length >= 3) {
			if (args[2].length > 0) {
				config.chipSelect = Utils.parseInteger(args[2]);
				if (isNaN(config.chipSelect))
					return "Invalid SPI chip select (not a number)."
			}
		}

		if (args.length >= 2) {
			if (args[1].length > 0) {
				config.ioset = Utils.parseInteger(args[1]);
				if (isNaN(config.ioset))
					return "Invalid SPI ioset (not a number)."
			}
		}

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.instance = Utils.parseInteger(args[0]);
				if (isNaN(config.instance))
					return "Invalid SPI instance (not a number)."
			}
		}

		return true;
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: serialflash:[<instance>]:[<ioset>]:[<npcs>]:[<frequency>]",
		        "Parameters:",
		        "    instance   SPI controller instance",
		        "    ioset      I/O set",
		        "    npcs       SPI chip select number",
		        "    frequency  SPI clock frequency in MHz",
		        "Examples: ",
		        "    serialflash           use default board settings",
		        "    serialflash:0:1:0:66  use fully custom settings (SPI0, IOSET1, NPCS0, 66Mhz)",
		        "    serialflash::::20     use default board settings but force frequency to 20Mhz"]
	}
}
