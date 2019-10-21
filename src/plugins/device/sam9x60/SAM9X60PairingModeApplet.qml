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
	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(args) {
		if (args.length > 1)
			return "Invalid number of arguments."

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
		return ["Syntax: pairingmode:[<algo>]",
			"Parameters:",
			"    algo            Signature algorithm for authentication (cmac or rsa)",
			"Examples:",
			"    pairingmode:cmac  Signature algorithm is set to AES-256-CMAC",
			"    pairingmode:rsa   Signature algorithm is set to RSA"]
	}
}
