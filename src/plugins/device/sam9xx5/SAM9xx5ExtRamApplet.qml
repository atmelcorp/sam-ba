/*
 * Copyright (c) 2016, Atmel Corporation.
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
	name: "extram"
	description: "External RAM"
	codeUrl: Qt.resolvedUrl("applets/applet-extram_sam9x35-generic_sram.bin")
	codeAddr: 0x300000
	mailboxAddr: 0x300004
	commands: [
		AppletCommand { name:"initialize"; code:0 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.extramPreset === "undefined")
			throw new Error("Incomplete configuration, missing value for extramPreset")

		var args = defaultInitArgs(connection, device)
		var config = [ 0, device.config.extramPreset ]
		Array.prototype.push.apply(args, config)
		return args
	}
}
