/*
 * Copyright (c) 2019, Microchip Technology.
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
	name: "pairingmode"
	description: "Convert a master bootstrap into a paired bootstrap"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"update"; code:0x38 }
	]

	readonly property int statusSuccess: 0
	readonly property int statusSeek: 11
	readonly property int statusBadOffsetOrLength: 12
	readonly property int statusFail: 15

	readonly property int algoCMAC: 0
	readonly property int algoRSA: 1
	readonly property int algoECDSA: 2

	property var algo

	/*! \internal */
	function buildInitArgs() {
		if (typeof algo === "undefined")
			throw new Error("missing value for algo")

		var args = defaultInitArgs()
		args.push(algo)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return [ "translate" ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "translate") {
			return ["* translate - convert a bootstrap master image into a bootstrap paired image",
				"Syntax:",
				"    translate:<master_input>:<paired_output>",
				"Examples:",
				"    translate:at91bootstrap.cip:at91bootstrap_paired.cip"]
		}
	}

	/*! \internal */
	function commandLineCommandTranslate(args) {
		if (args.length !== 2)
			throw new Error("Invalid number of arguments (expected 2).")

		// param (required)
		if (args[0].length === 0)
			throw new Error("Invalid <master_input> parameter (empty)")
		var masterFile = args[0]

		if (args[1].length === 1)
			throw new Error ("Invalid <paired_output> parameter (empty)")
		var pairedFile = args[1]

		var master = File.open(masterFile, false)
		if (!master)
			throw new Error("Could not read from master file '" + masterFile + "'")

		// save real file size (without padding) then add padding to align the file size to the page size
		var realSize = master.size()
		if ((realSize & (pageSize - 1)) !== 0) {
			var paddingAfter = pageSize - (realSize & (pageSize - 1))

			master.setPaddingAfter(paddingAfter)
		}

		var paired = File.open(pairedFile, true)
		if (!paired) {
			master.close()
			throw new Error("Could not write into paired file '" + pairedFile + "'")
		}

		try {
			var cmd = command("update")

			var offset = 0
			var numPages = master.size() / pageSize
			var remaining = realSize
			var seekPages = 0 // unlimited
			while (numPages > 0) {
				var length
				var applet_args
				var data
				var status

				master.seek(offset * pageSize)
				paired.seek(offset * pageSize)

				if (seekPages !== 0)
					length = seekPages
				else
					length = Math.min(numPages, bufferPages)

				data = master.read(length * pageSize)
				if (data === undefined || data.byteLength !== length * pageSize)
					throw new Error("Could not write pages at address "
							+ Utils.hex(offset * pageSize, 8)
							+ " (read from file '" + masterFile + "' failed)")

				if (!connection.appletBufferWrite(data))
					throw new Error("Could not write pages at address "
							+ Utils.hex(offset * pageSize, 8)
							+ " (write to applet buffer failed)")

				applet_args = [ offset, length ]
				status = connection.appletExecute(cmd, applet_args)
				if (status === undefined)
					throw new Error("Failed to update the bootstrap stream at address " +
							Utils.hex(offset * pageSize, 8) +
							" (applet did not complete)")
				if (status !== statusSuccess && status !== statusSeek)
					throw new Error("Failed to update the bootstrap stream at address " +
							Utils.hex(offset * pageSize, 8) +
							" (status: " + status + ")")

				if (status === statusSeek)
					seekPages = connection.appletMailboxRead(2)
				else
					seekPages = 0

				length = connection.appletMailboxRead(1)
				if (length === 0) {
					offset = connection.appletMailboxRead(0)
					continue
				}

				data = connection.appletBufferRead(length * pageSize)
				if (data === undefined || data.byteLength !== length * pageSize)
					throw new Error("Could not read pages at address "
							+ Utils.hex(offset * pageSize, 8)
							+ " (read from applet buffer failed)")

				var size = Math.min(remaining, data.byteLength)
				var written = paired.write(data.slice(0, size))
				if (written !== size)
					throw new Error("Could not write to paired file '" + pairedFile + "'")

				offset = connection.appletMailboxRead(0)
				numPages -= length
				remaining -= size
			}
		}
		finally {
			paired.close()
			master.close()
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "translate")
			return commandLineCommandTranslate(args)
		else
			return "Unknown command."
	}
}
