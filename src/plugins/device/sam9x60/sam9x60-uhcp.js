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

.pragma library

var OTPC_UHC0R			= 0
var OTPC_UHC0R_JTAGDIS_Pos	= 0
var OTPC_UHC0R_JTAGDIS_Msk	= 0xff << OTPC_UHC0R_JTAGDIS_Pos

var OTPC_UHC1R			= 1
var OTPC_UHC1R_URDDIS		= 1 << 0
var OTPC_UHC1R_UPGDIS		= 1 << 1
var OTPC_UHC1R_UHCINVDIS	= 1 << 2
var OTPC_UHC1R_UHCLKDIS		= 1 << 3
var OTPC_UHC1R_UHCPGDIS		= 1 << 4
var OTPC_UHC1R_BCINVDIS		= 1 << 5
var OTPC_UHC1R_BCLKDIS		= 1 << 6
var OTPC_UHC1R_BCPGDIS		= 1 << 7
var OTPC_UHC1R_SBCINVDIS	= 1 << 8
var OTPC_UHC1R_SBCLKDIS		= 1 << 9
var OTPC_UHC1R_SBCPGDIS		= 1 << 10
var OTPC_UHC1R_CINVDIS		= 1 << 14
var OTPC_UHC1R_CLKDIS		= 1 << 15
var OTPC_UHC1R_CPGDIS		= 1 << 16
var OTPC_UHC1R_URFDIS		= 1 << 17

/*
	\qmlmethod string UHCP::toText(Uint32Array value)
	Convertsa user hardware configuration packet \a value to text for user display.
*/
function toText(value) {
	if (value.length !== 2)
		throw new Error("Invalid User Hardware Configuration Packet")

	var text = []

	if (value[OTPC_UHC0R] & OTPC_UHC0R_JTAGDIS_Msk)
		text.push("JTAGDIS")

	var otpc_hc1r = value[OTPC_UHC1R]
	if (otpc_hc1r & OTPC_UHC1R_URFDIS)
		text.push("URFDIS")
	if (otpc_hc1r & OTPC_UHC1R_CPGDIS)
		text.push("CPGDIS")
	if (otpc_hc1r & OTPC_UHC1R_CLKDIS)
		text.push("CLKDIS")
	if (otpc_hc1r & OTPC_UHC1R_CINVDIS)
		text.push("CINVDIS")
	if (otpc_hc1r & OTPC_UHC1R_SBCPGDIS)
		text.push("SBCPGDIS")
	if (otpc_hc1r & OTPC_UHC1R_SBCLKDIS)
		text.push("SBCLCKDIS")
	if (otpc_hc1r & OTPC_UHC1R_SBCINVDIS)
		text.push("SBCINVDIS")
	if (otpc_hc1r & OTPC_UHC1R_BCPGDIS)
		text.push("BCPGDIS")
	if (otpc_hc1r & OTPC_UHC1R_BCLKDIS)
		text.push("BCLKDIS")
	if (otpc_hc1r & OTPC_UHC1R_BCINVDIS)
		text.push("BCINVDIS")
	if (otpc_hc1r & OTPC_UHC1R_UHCPGDIS)
		text.push("UHCPGDIS")
	if (otpc_hc1r & OTPC_UHC1R_UHCLKDIS)
		text.push("UHCLKDIS")
	if (otpc_hc1r & OTPC_UHC1R_UHCINVDIS)
		text.push("UHCINVDIS")
	if (otpc_hc1r & OTPC_UHC1R_UPGDIS)
		text.push("UPGDIS")
	if (otpc_hc1r & OTPC_UHC1R_URDDIS)
		text.push("URDDIS")

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array BCP::fromText(string text)
	Converts a string to a user hardware configuration packet \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var names = ["URDDIS",
	             "UPGDIS",
	             "UHCINVDIS",
	             "UHCLKDIS",
	             "UHCPGDIS",
	             "BCINVDIS",
	             "BCLKDIS",
	             "BCPGDIS",
	             "SBCINVDIS",
	             "SBCLKDIS",
	             "SBCPGDIS",
	             "CINVDIS",
	             "CLKDIS",
	             "CPGDIS",
	             "URFDIS"]
	var values = [OTPC_UHC1R_URDDIS,
	              OTPC_UHC1R_UPGDIS,
	              OTPC_UHC1R_UHCINVDIS,
	              OTPC_UHC1R_UHCLKDIS,
	              OTPC_UHC1R_UHCPGDIS,
	              OTPC_UHC1R_BCINVDIS,
	              OTPC_UHC1R_BCLKDIS,
	              OTPC_UHC1R_BCPGDIS,
	              OTPC_UHC1R_SBCINVDIS,
	              OTPC_UHC1R_SBCLKDIS,
	              OTPC_UHC1R_SBCPGDIS,
	              OTPC_UHC1R_CINVDIS,
	              OTPC_UHC1R_CLKDIS,
	              OTPC_UHC1R_CPGDIS,
	              OTPC_UHC1R_URFDIS]
	var uhcp = new Uint32Array(2)
	for (var i = 0; i < entries.length; i++) {
		if (entries[i].length === 0)
			continue

		if (entries[i].toUpperCase() === "JTAGDIS") {
			uhcp[OTPC_UHC0R] = 1
			continue
		}

		var index = names.indexOf(entries[i].toUpperCase())
		if (index < 0)
			throw new Error("Invalid UHCP value '" + entries[i] + "'")
		uhcp[OTPC_UHC1R] |= values[index]
	}
	return uhcp
}
