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
import SAMBA 3.2

Item {
	function handle_connectionOpened()
	{
		Tool.port.initializeApplet(Tool.appletName)
		for (var i = 0; i < Tool.commands.length; i++) {
			var args = Tool.commands[i]
			var command = args.shift()
			print("Executing command '" + Tool.commands[i].join(":") + "'")
			var errMsg
			if (args.length === 1 && args[0] === "help")
				errMsg = Tool.port.applet.commandLineCommandHelp(command)
			else
				errMsg = Tool.port.applet.commandLineCommand(command, args)
			if (Array.isArray(errMsg)) {
				for (var j = 0; j < errMsg.length; j++)
					Tool.error(errMsg[j])
				break;
			}
			else if (typeof errMsg === "string") {
				Tool.error("Error: Command '" + Tool.commands[i].join(":") +
				           "': " + errMsg)
				Script.returnCode = -1
				break
			}
		}
	}

	function handle_connectionFailed()
	{
		Script.returnCode = -1
	}

	Component.onCompleted: {
		Tool.port.connectionOpened.connect(handle_connectionOpened)
		Tool.port.connectionFailed.connect(handle_connectionFailed)
		Tool.port.open()
	}
}
