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

var SECURE_BOOT_ENABLED   = 0
var AUTH_MODE             = 1
var PAIRING_MODE_ENABLED  = 2
var CUSTOMER_KEY_WRITTEN  = 3
var SEC_BOOT_CFG_PKT_SIZE = 8

/*!
	\qmlmethod string SBCP::toText(Uint32Array value)
	Converts a secure boot config packet \a value to text for user display.
*/
function toText(value)
{
    if (value.length !== SEC_BOOT_CFG_PKT_SIZE)
	throw new Error("Invalid Secure Boot Config Packet")

	var text = []

	if (value[SECURE_BOOT_ENABLED])
		text.push("SECURE_BOOT_ENABLED")

	if (value[AUTH_MODE])
		text.push("RSA_SIGNATURE")

	if (value[PAIRING_MODE_ENABLED])
		text.push("PAIRING_MODE_ENABLED")

	if (value[CUSTOMER_KEY_WRITTEN])
		text.push("CUSTOMER_KEY_WRITTEN")

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array SBCP::fromText(string text)
	Converts a \a text to a secure boot config packet.
*/
function fromText(text) {
    var entries = text.split(',')

    var sbcp = new Uint32Array(SEC_BOOT_CFG_PKT_SIZE)
    sbcp[SECURE_BOOT_ENABLED] = 1
    for (var i = 0; i < entries.length; i++) {
	if (entries[i].toUpperCase() === "RSA_SIGNATURE") {
	    sbcp[AUTH_MODE] = 1
	} else if (entries[i].toUpperCase() === "PAIRING_MODE_ENABLED") {
	    sbcp[PAIRING_MODE_ENABLED] = 1
	} else if (entries[i].toUpperCase() === "CUSTOMER_KEY_WRITTEN") {
	    sbcp[CUSTOMER_KEY_WRITTEN] = 1
	}
    }

    return sbcp
}
