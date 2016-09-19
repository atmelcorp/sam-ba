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
	name: "qspiflash"
	description: "QSPI Flash"
	codeUrl: Qt.resolvedUrl("applets/applet-qspiflash_sama5d2-generic_sram.bin")
	codeAddr: 0x220000
	mailboxAddr: 0x220004
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.qspiInstance === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiInstance")

		if (typeof device.config.qspiIoset === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiIoset")

		if (typeof device.config.qspiFreq === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiFreq")

		var args = defaultInitArgs(connection, device)
		var config = [ device.config.qspiInstance,
		               device.config.qspiIoset,
		               Math.floor(device.config.qspiFreq * 1000000) ]
		Array.prototype.push.apply(args, config)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
		switch (args.length) {
		case 3:
			if (args[2].length > 0) {
				device.config.qspiFreq = Utils.parseInteger(args[2]);
				if (isNaN(device.config.qspiFreq))
					return "Invalid QSPI frequency (not a number)."
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				device.config.qspiIoset = Utils.parseInteger(args[1]);
				if (isNaN(device.config.qspiIoset))
					return "Invalid QSPI ioset (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				device.config.qspiInstance = Utils.parseInteger(args[0]);
				if (isNaN(device.config.qspiInstance))
					return "Invalid QSPI instance (not a number)."
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
		return ["Syntax: qspiflash:[<instance>]:[<ioset>]:[<frequency>]",
		        "Parameters:",
		        "    instance   QSPI controller instance",
		        "    ioset      I/O set",
		        "    frequency  QSPI clock frequency in MHz",
		        "Examples:",
		        "    qspiflash         use default board settings",
		        "    qspiflash:0:3:66  use fully custom settings (QSPI0, IOSET3, 66Mhz)",
		        "    qspiflash:::20    use default board settings but force frequency to 20Mhz"]
	}
}
