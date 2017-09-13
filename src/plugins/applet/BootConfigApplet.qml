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
	name: "bootconfig"
	description: "Boot Configuration"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"readBootCfg"; code:0x34 },
		AppletCommand { name:"writeBootCfg"; code:0x35 }
	]

	property var configParams: []

	/*! \internal */
	function callReadBootCfg(index)
	{
		var status, cmd

		cmd = command("readBootCfg")
		if (cmd) {
			status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Read Boot Config command failed (status=" +
						status + ")")
			return connection.appletMailboxRead(0)
		} else {
			throw new Error("Applet does not support 'Read Boot Config' command")
		}
	}

	/*!
		\qmlmethod int Applet::readBootCfg(int index)
		\brief Read the boot configuration

		Read and returns the boot configuration at index \a index using the applet
		'Read Boot Config' command.

		Throws an \a Error if the applet has no 'Read Boot Config' command or
		if an error occured during calling the applet command
	*/
	function readBootCfg(index)
	{
		return callReadBootCfg(index)
	}

	/*! \internal */
	function callWriteBootCfg(index, value)
	{
		var status, cmd

		cmd = command("writeBootCfg")
		if (cmd) {
			status = connection.appletExecute(cmd, [index, value])
			if (status !== 0)
				throw new Error("Write Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Write Boot Config' command")
		}
	}

	/*!
		\qmlmethod void Applet::writeBootCfg(int index, int value)
		\brief Write the boot configuration

		Write the boot configuration \a value at index \a index using the
		applet 'Write Boot Config' command.

		Throws an \a Error if the applet has no 'Write Boot Config' command or
		if an error occured during calling the applet command
	*/
	function writeBootCfg(index, value)
	{
		callWriteBootCfg(index, value)
	}

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
		var value = Utils.parseInteger(args[1])
		if (isNaN(value))
			value = configValueFromText(index, args[1])
		if (isNaN(value) || typeof value === "undefined")
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
		if (command === "readcfg")
			return commandLineCommandReadBootConfig(args);
		else if (command === "writecfg")
			return commandLineCommandWriteBootConfig(args);
		else
			return "Unknown command."
	}
}
