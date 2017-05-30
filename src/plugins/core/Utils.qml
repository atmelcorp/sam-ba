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

pragma Singleton
import QtQuick 2.3
import SAMBA 3.2

/*!
\qmltype Utils
\inqmlmodule SAMBA
\brief The Utils type is a singleton that contains misc. utility functions.
*/
UtilsBase {
	/*!
		\qmlmethod string Utils::hex(number value, number digits)
		\brief Convert \a value to a hexadecimal string with at least \a digits.

		Returns the hexadecimal string
	*/
	function hex(value, digits) {
		if (typeof value === "undefined")
			return
		var str = value.toString(16)
		while (str.length < digits) {
			str = "0" + str
		}
		return "0x" + str
	}

	/*!
		\qmlmethod string Utils::parseInteger(string text)
		\brief Convert \a decimal or hexadecimal string to a number.

		Returns the parsed number, or Number.NaN if the string could
		not be parsed.
	*/
	function parseInteger(obj) {
		var text = obj.toString().trim()

		var hexPattern = /^0x[0-9a-f]+$/i
		if (hexPattern.test(text))
			return parseInt(text, 16)

		var decPattern = /^-?[0-9]+$/
		if (decPattern.test(text))
			return parseInt(text, 10)

		return Number.NaN
	}
}
