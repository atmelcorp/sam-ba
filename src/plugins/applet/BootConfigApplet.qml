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
import SAMBA 3.1

/*! \internal */
Applet {
	name: "bootconfig"
	description: "Boot Configuration"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"readBootCfg"; code:0x34 },
		AppletCommand { name:"writeBootCfg"; code:0x35 }
	]

	property var configParams: []

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function configParamIndex(param) {
		return configParams.indexOf(param.toUpperCase())
	}

	/*! \internal */
	function configValueFromText(index, value) {
		// should be overridden by sub-class
		return
	}

	/*! \internal */
	function configValueToText(index, value) {
		// should be overridden by sub-class
		return
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return [ "readcfg", "writecfg" ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return ["* readcfg - read boot configuration",
			        "Syntax:",
			        "    readcfg:<parameter>"]
		}
		else if (command === "writecfg") {
			return ["* writecfg - write boot configuration",
			        "Syntax:",
			        "    writecfg:<parameter>:<configuration>"]
		}
	}

	/*! \internal */
	function commandLineCommandReadBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 0)
			return "Unknown configuration parameter"

		var value = readBootCfg(index)
		var text = configValueToText(index, value)
		if (typeof text === "undefined")
			print(configParams[index] + "=" + Utils.hex(value, 8))
		else
			print(configParams[index] + "=" + Utils.hex(value, 8) + " / " + text)
	}

	/*! \internal */
	function commandLineCommandWriteBootConfig(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 0)
			return "Unknown configuration parameter"

		// value (required)
		if (args[1].length === 0)
			return "Invalid value parameter (empty)"
		var value = configValueFromText(index, args[1])
		if (typeof value === "undefined")
			value = Utils.parseInteger(args[1])
		if (isNaN(value))
			return "Invalid value parameter"
		var text = configValueToText(index, value)
		if (typeof text === "undefined")
			print("Setting " + configParams[index] + " to " + Utils.hex(value, 8))
		else
			print("Setting " + configParams[index] + " to " + Utils.hex(value, 8) + " (" + text + ")")
		writeBootCfg(index, value)
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "readcfg") {
			return commandLineCommandReadBootConfig(args);
		}
		else if (command === "writecfg") {
			return commandLineCommandWriteBootConfig(args);
		}
		else {
			return defaultCommandLineCommandHandler(command, args)
		}
	}

}
