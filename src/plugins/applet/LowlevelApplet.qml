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
	name: "lowlevel"
	description: "Low-Level"
	commands: [
		AppletCommand { name:"initialize"; code:0 }
	]

	/*! \internal */
	function buildInitArgs() {
		var args = defaultInitArgs()
		Array.prototype.push.apply(args, [0, 0, 0])
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return [ ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		return "Unknown command."
	}
}
