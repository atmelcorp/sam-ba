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

/*!
	\qmlmethod string BSCR::toText(int value)
	Converts a boot sequence config register \a value to text for user display.
*/
function toText(value) {
	if (value !== 0)
		return "EMULATION_ENABLED"

	return "EMULATION_DISABLED"
}

/*!
	\qmlmethod int BSCR::fromText(string text)
	Converts a string to a boot sequence config register \a value.
*/
function fromText(text) {
	if (text.toUpperCase() === "EMULATION_ENABLED")
		return 1
	if (text.toUpperCase() === "EMULATION_DISABLED")
		return 0

	throw new Error("Invalid BSCR value '" + text + "'")
}
