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

Item {
	function handleMonitorCommands() {
		Tool.returnCode = 0

		for (var i = 0; i < Tool.commands.length; i++) {
			var args = Tool.commands[i]
			var command = args.shift()
			var errMsg
			if (args.length === 1 && args[0] === "help")
				errMsg = Tool.port.commandLineCommandHelp(command)
			else
				errMsg = Tool.port.commandLineCommand(command, args)
			if (Array.isArray(errMsg)) {
				for (var j = 0; j < errMsg.length; j++)
					Tool.error(errMsg[j])
				break;
			}
			else if (typeof errMsg === "string") {
				Tool.error("Error: Command '" + Tool.commands[i].join(":") +
						   "': " + errMsg)
				Tool.returnCode = -1
				break
			}
		}
	}

	function handle_portOpened() {
		handleMonitorCommands();
	}

	function handle_portFailed(message) {
		Tool.error(message)
		Tool.returnCode = -1
	}

	Component.onCompleted: {
		Tool.port.connectionOpened.connect(handle_portOpened)
		Tool.port.connectionFailed.connect(handle_portFailed)
		Tool.port.open()
	}
}
