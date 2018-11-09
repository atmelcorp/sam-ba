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

var SECURE_BOOT_ENABLED   = 1 << 0
var RSA_SIGNATURE         = 1 << 1
var PAIRING_MODE_ENABLED  = 1 << 2
var CUSTOMER_KEY_WRITTEN  = 1 << 3

/*!
	\qmlmethod string SBCP::toText(interger value)
	Converts a secure boot config packet \a value to text for user display.
*/
function toText(value)
{
	var text = []

	if (value & SECURE_BOOT_ENABLED)
		text.push("SECURE_BOOT_ENABLED")

	if (value & RSA_SIGNATURE)
		text.push("RSA_SIGNATURE")

	if (value & PAIRING_MODE_ENABLED)
		text.push("PAIRING_MODE_ENABLED")

	if (value & CUSTOMER_KEY_WRITTEN)
		text.push("CUSTOMER_KEY_WRITTEN")

	return text.join(",")
}
