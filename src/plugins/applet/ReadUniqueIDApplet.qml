/*
 * Copyright (c) 2019, Atmel Corporation.
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
	name: "readuniqueid"
	description: "Read Unique ID"
	commands: [
		AppletCommand { name:"initialize"; code:0 }
	]

	property var fileName

	function initialize()
	{
		var args, status, cmd
		var uniqueID = ""

		cmd = command("initialize")

		args = buildInitArgs()
		status = connection.appletExecute(cmd, args)

		if (status === 0) {
			bufferAddr = connection.appletMailboxRead(0)
			bufferSize = connection.appletMailboxRead(1)

			var buff = connection.appletBufferRead(bufferSize)
			if (typeof buff !== "object" || buff.byteLength !== bufferSize)
				throw new Error("Read Unique ID command failed")

			var uid = new Uint32Array(buff)

			for (var i = 0;  i < (bufferSize / 4); i++)
				print("UID[" + i + "] = " + Utils.hex(uid[i], 8))

			if (fileName) {
				var file = File.open(fileName, true)
				if (!file)
					throw new Error("Could not open file '" + fileName + "' for writing UID.")

				var written = file.write(buff)
				if (written != bufferSize)
					throw new Error("Could not write to file '" + fileName + "'")

				file.close()
			}
		} else {
			bufferAddr = 0
			bufferSize = 0
			pageSize = 0
			memoryPages = 0
			eraseSupport = 0
			nandHeader = 0
			throw new Error("Could not initialize applet" +
					" (status: " + status + ")")
		}
	}

	/* -------- Command Line Handling -------- */
	/*! \internal */
	function commandLineParse(args)	{
		if (args.length >= 2)
			return "Invalid number of arguments."

		if (args.length === 1) {
			if (args[0].length > 0) {
				fileName = args[0].toString().trim()
			}
		}

		return true;
	}

	/*! \internal */
	function commandLineCommands() {
		return []
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: readuniqueid:[<filename>]",
			"Parameters:",
		        "    filename   binary file where the UID is stored",
			"Examples:",
		        "    readuniqueid                  prints the UID on screen",
		        "    readuniqueid:uidFile.bin      stores UID in binary format in uidFile.bin",
		]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		return "Unknown command."
	}
}
