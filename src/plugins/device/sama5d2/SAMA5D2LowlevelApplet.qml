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
	name: "lowlevel"
	description: "Low-Level"
	codeUrl: Qt.resolvedUrl("applets/applet-lowlevel_sama5d2-generic_sram.bin")
	codeAddr: 0x220000
	mailboxAddr: 0x220004
	commands: [
		AppletCommand { name:"initialize"; code:0 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		var args = defaultInitArgs(connection, device)
		Array.prototype.push.apply(args, [0, 0, 0])
		return args
	}
}
