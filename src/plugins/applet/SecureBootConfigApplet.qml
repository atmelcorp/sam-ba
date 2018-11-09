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

/*! \internal */
Applet {
	name: "securebootconfig"
	description: "Secure Boot Configuration"
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"readSecureBootCfg"; code:0x34 },
		AppletCommand { name:"createSecureBootCfg"; code:0x35 },
		AppletCommand { name:"invalidateSecureBootCfg"; code:0x38 },
		AppletCommand { name:"lockSecureBootCfg"; code:0x39 },
		AppletCommand { name:"refresh"; code:0x40 }
	]

	/*! \internal */
	function readSecureBootCfg()
	{
		var status, cmd

		cmd = command("readSecureBootCfg")
		status = connection.appletExecute(cmd, [])
		if (status !== 0)
			throw new Error("Read Secure Boot Config command failed (status=" +
					status + ")")
		return connection.appletMailboxRead(0)
	}

	/* !\internal */
	function createSecureBootCfg()
	{
		var status, cmd

		cmd = command("createSecureBootCfg")
		status = connection.appletExecute(cmd, [])
		if (status !== 0)
			throw new Error("Create Secure Boot Config command failed (status=" +
					status + ")")
	}

	/* !\internal */
	function invalidateSecureBootCfg()
	{
		var status, cmd

		cmd = command("invalidateSecureBootCfg")
		status = connection.appletExecute(cmd, [])
		if (status !== 0)
			throw new Error("Invalidate Secure Boot Config command failed (status=" +
					status + ")")
	}

	/* !\internal */
	function lockSecureBootCfg()
	{
		var status, cmd

		cmd = command("lockSecureBootCfg")
		status = connection.appletExecute(cmd, [])
		if (status !== 0)
			throw new Error("Lock Secure Boot Config command failed (status=" +
					status + ")")
	}

	/* !\internal */
	function refreshSecureBootCfg()
	{
		var status, cmd

		cmd = command("refreshSecureBootCfg")
		status = connection.appletExecute(cmd, [])
		if (status !== 0)
			throw new Error("Refresh Secure Boot Config command failed (status=" +
					status + ")")
	}

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function secureBootCfgToText(value) {
		// should be overridden by sub-class
		return
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands()
	{
		return [ "readcfg", "createcfg", "invalidatecfg", "lockcfg", "refreshcfg" ]
	}

	/*! \internal */
	function commandLineCommandHelp(command)
	{
		if (command === "readcfg") {
			return ["* readcfg - read secure boot configuration",
				"Syntax:",
				"    readcfg"]
		}
		else if (command === "createcfg") {
			return ["* createcfg - create empty secure boot configuration and enable the secure-boot mode",
				"Syntax:",
				"    createcfg"]
		}
		else if (command === "invalidatecfg") {
			return ["* invalidatecfg - invalidate secure boot configuration",
				"Syntax:",
				"    invalidatecfg"]
		}
		else if (command === "lockcfg") {
			return ["* lockcfg - lock secure boot configuration",
				"Syntax:",
				"    lockcfg"]
		}
		else if (command === "refreshcfg") {
			return ["* refreshcfg - refresh secure boot configuration",
				"Syntax:",
				"    refreshcfg"]
		}
	}

	/*! \internal */
	function commandLineCommandReadConfig(args)
	{
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		var value = readSecureBootCfg()
		var text = secureBootCfgToText(value)
		print("SBCP=" + Utils.hex(value, 8) + " / " + text)
	}

	/*! \internal */
	function commandLineCommandCreateConfig(args)
	{
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		createSecureBootCfg()
	}

	/*! \internal */
	function commandLineCommandInvalidateConfig(args)
	{
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		invalidateSecureBootCfg()
	}

	/*! \internal */
	function commandLineCommandLockConfig(args)
	{
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		lockSecureBootCfg()
	}

	/*! \internal */
	function commandLineCommandRefreshConfig(args)
	{
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		refreshSecureBootCfg()
	}

	/*! \internal */
	function commandLineCommand(command, args)
	{
		if (command === "readcfg")
			return commandLineCommandReadConfig(args)
		else if (command === "createcfg")
			return commandLineCommandCreateConfig(args)
		else if (command === "invalidatecfg")
			return commandLineCommandInvalidateConfig(args)
		else if (command === "lockcfg")
			return commandLineCommandLockConfig(args)
		else if (command === "refreshcfg")
			return commandLineCommandRefreshConfig(args)
		else
			return "Unknown command."
	}
}
