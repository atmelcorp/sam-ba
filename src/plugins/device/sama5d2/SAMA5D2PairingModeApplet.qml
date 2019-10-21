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
import SAMBA.Applet 3.2

/*! \internal */
PairingModeApplet {
	property var forceSettings: 0
	property var keysInFuse: 0

	/*! \internal */
	function buildInitArgs() {
		if (typeof algo === "undefined")
			throw new Error("missing value for algo")

		var args = defaultInitArgs()
		args.push(algo)
		args.push(forceSettings)
		args.push(keysInFuse)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		if (args.length > 3)
			return "Invalid number of arguments."

		if (args.length >= 3 && args[2].length > 0) {
			keysInFuse = Utils.parseInteger(args[2])
			if (isNaN(keysInFuse))
				throw new Error("Invalid <keys_in_fuse> value (not a number).")
			keysInFuse = !!keysInFuse
		}

		if (args.length >= 2 && args[1].length > 0) {
			forceSettings = Utils.parseInteger(args[1])
			if (isNaN(forceSettings))
				throw new Error("Invalid <force_settings> value (not a number).")
			forceSettings = !!forceSettings
		}

		if (args.length >= 1 && args[0].length > 0) {
			if (args[0].toLowerCase() === "cmac") {
				algo = algoCMAC
			} else if (args[0].toLowerCase() === "rsa") {
				algo = algoRSA
			} else {
				throw new Error("Unknown signature algorithm.")
			}
		} else {
			throw new Error("Missing signature algorithm.")
		}

		return true
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: pairingmode:[<algo>]:[<force_settings>]:[<keys_in_fuse>]",
			"Parameters:",
			"    algo            Signature algorithm for authentication (cmac or rsa)",
			"    force_settings  By-pass ROM code settings and force settings from applet parameters",
			"    keys_in_fuse    If <force_settings> is set, load customer keys from fuses",
			"Examples:",
			"    pairingmode:cmac  Signature algorithm is set to AES-256-CMAC",
			"    pairingmode:rsa   Signature algorithm is set to RSA"]
	}
}
