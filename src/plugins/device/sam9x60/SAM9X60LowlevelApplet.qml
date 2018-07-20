/*
 * Copyright (c) 2018, Microchip.
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
import SAMBA.Applet 3.2

/*! \internal */
LowlevelApplet {
	/*! \internal */
	function buildInitArgs() {
		var config = device.config.lowlevel

		if (typeof config.preset === "undefined")
			config.preset = 0

		var args = defaultInitArgs()
		Array.prototype.push.apply(args, [config.preset, 0, 0, 0])
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		if (args.length > 1)
			return "Invalid number of arguments."

		var config = device.config.lowlevel

		if (args.length >= 1) {
			if (args[0].length > 0) {
				config.preset = Utils.parseInteger(args[0])
				if (isNaN(config.preset))
					return "Invalid preset (not a number)."
			}
		}

		return true
	}

	/* \internal */
	function commandLineHelp() {
		return ["Syntax: lowlevel:[<preset>]",
			"Parameters:",
			"    preset  System clock configuration",
			"Examples: ",
			"    lowlevel    use default board settings if defined, preset 0 otherwise",
			"    lowlevel:0  use preset 0 for system clock configuration"]
	}
}
