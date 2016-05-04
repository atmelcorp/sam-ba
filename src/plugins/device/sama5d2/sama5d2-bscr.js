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

.pragma library

/*! \qmlproperty int BSCR::VALID
    \brief BSCR bits for indicating that boot config word should come from BUREG. */
var VALID = 1 << 2
var BUREG_MASK = 3
/*! \qmlproperty int BSCR::BUREG0
    \brief BSCR bits for indicating that boot config word is BUREG0. */
var BUREG0     = 0
/*! \qmlproperty int BSCR::BUREG1
    \brief BSCR bits for indicating that boot config word is BUREG1. */
var BUREG1     = 1
/*! \qmlproperty int BSCR::BUREG2
    \brief BSCR bits for indicating that boot config word is BUREG2. */
var BUREG2     = 2
/*! \qmlproperty int BSCR::BUREG3
    \brief BSCR bits for indicating that boot config word is BUREG3. */
var BUREG3     = 3

/*!
	\qmlmethod string BSCR::toText(int value)
	Converts a boot sequence config register \a value to text for user display.
*/
function toText(value) {
	var text = []

	switch (value & BUREG_MASK) {
	case BUREG0:
		text.push("BUREG0")
		break;
	case BUREG1:
		text.push("BUREG1")
		break;
	case BUREG2:
		text.push("BUREG2")
		break;
	case BUREG3:
		text.push("BUREG3")
		break;
	}

	if (value & VALID)
		text.push("VALID")

	return text.join(",")
}

/*!
	\qmlmethod int BSCR::fromText(string text)
	Converts a string to a boot sequence config register \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var names = ["VALID", "BUREG0", "BUREG1", "BUREG2", "BUREG3"]
	var values = [VALID, BUREG0, BUREG1, BUREG2, BUREG3]
	var bscr = 0
	for (var i = 0; i < entries.length; i++) {
		var index = names.indexOf(entries[i].toUpperCase())
		if (index < 0)
			throw new Error("Invalid BSCR value '" + entries[i] + "'")
		bscr |= values[index]
	}
	return bscr
}
