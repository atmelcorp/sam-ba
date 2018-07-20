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

var DISABLE_MONITOR	= 0
var CONSOLE_IOSET	= 4

var MAX_BOOTABLE_INTERF	= 7
var BOOT_CFG_PKT_SIZE	= 19

var IOSET_OFF		= 0
var IOSET_MASK		= 0xf << IOSET_OFF

var INST_ID_OFF		= 4
var INST_ID_MASK	= 0xf << INST_ID_OFF

var TYPE_OFF		= 8
var TYPE_MASK		= 0xf << TYPE_OFF
var TYPE_DISABLED	= 0x0 << TYPE_OFF
var TYPE_QSPI		= 0x1 << TYPE_OFF
var TYPE_SPI		= 0x2 << TYPE_OFF
var TYPE_SDMMC		= 0x3 << TYPE_OFF
var TYPE_NFC		= 0x4 << TYPE_OFF

var CD_PIN_OFF		= 0
var CD_PIN_MASK		= 0x1f << CD_PIN_OFF

var CD_PID_OFF		= 5
var CD_PID_MASK		= 0x3 << CD_PID_OFF

var CD_ENABLED		= 1 << 7

var CD_MAGIC_OFF	= 8
var CD_MAGIC_MASK	= 0xff << CD_MAGIC_OFF
var CD_MAGIC_PASSWORD	= 0x96 << CD_MAGIC_OFF

/*!
	\qmlmethod string BCP::toText(Uint32Array value)
	Converts a boot config packet \a value to text for user display.
*/
function toText(value) {
	if (value.length !== BOOT_CFG_PKT_SIZE)
		throw new Error("Invalid Boot Config Packet")

	var text = []

	if (value[DISABLE_MONITOR] !== 0)
		text.push("MONITOR_DISABLED")

	if (value[CONSOLE_IOSET] >= 1 && value[CONSOLE_IOSET] <= 13) {
		var inst_id = value[CONSOLE_IOSET] - 1
		text.push("FLEXCOM" + inst_id + "_USART_IOSET1")
	} else {
		text.push("DBGU")
	}

	for (var i = 0; i < MAX_BOOTABLE_INTERF; i++) {
		var details = value[2 * i + 5]
		var mem_cfg = value[2 * i + 6]
		var ioset = ((details & IOSET_MASK) >> IOSET_OFF) + 1
		var inst_id = (details & INST_ID_MASK) >> INST_ID_OFF
		var boot_entry

		switch (details & TYPE_MASK) {
		default:
		case TYPE_DISABLED:
			continue
		case TYPE_QSPI:
			boot_entry = "QSPI" + inst_id + "_IOSET" + ioset
			if (mem_cfg !== 0)
				boot_entry += "_XIP"
			break
		case TYPE_SPI:
			boot_entry = "FLEXCOM" + inst_id + "_SPI_IOSET" + ioset
			break
		case TYPE_SDMMC:
			boot_entry = "SDMMC" + inst_id + "_IOSET" + ioset
			if (((mem_cfg & CD_MAGIC_MASK) == CD_MAGIC_PASSWORD) &&
			    (mem_cfg & CD_ENABLED)) {
				var pid = (mem_cfg & CD_PID_MASK) >> CD_PID_OFF
				var pin = (mem_cfg & CD_PIN_MASK) >> CD_PIN_OFF

				boot_entry += "_P" + String.fromCharCode(0x41 + pid) + pin
			}
			break
		case TYPE_NFC:
			boot_entry = "NFC_IOSET" + ioset
			break
		}

		text.push(boot_entry)
	}

	return text.join(",")
}

/*!
	\qmlmethod Uint32Array BCP::fromText(string text)
	Converts a string to a boot config packet \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var console_regexp = /^FLEXCOM(\d{1,2})_USART_IOSET1$/i
	var qspi_regexp = /^QSPI(\d)_IOSET(\d)(.*)$/i
	var spi_regexp = /^FLEXCOM(\d)_SPI_IOSET(\d)$/i
	var sdmmc_regexp = /^SDMMC(\d)_IOSET(\d)(.*)$/i
	var nfc_regexp = /^NFC_IOSET(\d)$/i
	var pin_regexp = /^_P([A-D])([0-9]{1,2})$/i

	var inst_id
	var ioset
	var found
	var boot_entry = 0
	var bcp = new Uint32Array(BOOT_CFG_PKT_SIZE)
	for (var i = 0; i < entries.length; i++) {
		if (entries[i].toUpperCase() === "MONITOR_DISABLED") {
			bcp[DISABLE_MONITOR] = 1
		} else if ((found = entries[i].match(console_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			bcp[CONSOLE_IOSET] = inst_id + 1
		} else if ((found = entries[i].match(qspi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 5] = TYPE_QSPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			if (found[3].toUpperCase() === "_XIP")
				bcp[2 * boot_entry + 6] = 1
			boot_entry++
		} else if ((found = entries[i].match(spi_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 5] = TYPE_SPI |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			boot_entry++
		} else if ((found = entries[i].match(sdmmc_regexp)) !== null) {
			inst_id = parseInt(found[1], 10)
			ioset = parseInt(found[2], 10) - 1
			bcp[2 * boot_entry + 5] = TYPE_SDMMC |
					((ioset << IOSET_OFF) & IOSET_MASK) |
					((inst_id << INST_ID_OFF) & INST_ID_MASK)
			var pin_name
			if ((pin_name = found[3].match(pin_regexp)) !== null) {
				var pid = pin_name[1].charCodeAt(0) - 0x41
				var pin = parseInt(pin_name[2], 10)
				bcp[2 * boot_entry + 6] = CD_MAGIC_PASSWORD | CD_ENABLED |
						((pid << CD_PID_OFF) & CD_PID_MASK) |
						((pin << CD_PIN_OFF) & CD_PIN_MASK)
			}
			boot_entry++
		} else if ((found = entries[i].match(nfc_regexp)) !== null) {
			ioset = parseInt(found[1], 10) - 1
			bcp[2 * boot_entry + 5] = TYPE_NFC | ((ioset << IOSET_OFF) & IOSET_MASK)
			boot_entry++
		}
	}
	return bcp
}
