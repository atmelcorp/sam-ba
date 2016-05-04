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

/* Boot Config Word bits & masks */

var QSPI0_MASK          = 3 << 0
/*! \qmlproperty int BCW::QSPI0_IOSET1
    \brief Boot Config Word bits for booting on QSPI0 I/O set 1. */
var QSPI0_IOSET1        = 0 << 0
/*! \qmlproperty int BCW::QSPI0_IOSET2
    \brief Boot Config Word bits for booting on QSPI0 I/O set 2. */
var QSPI0_IOSET2        = 1 << 0
/*! \qmlproperty int BCW::QSPI0_IOSET3
    \brief Boot Config Word bits for booting on QSPI0 I/O set 3. */
var QSPI0_IOSET3        = 2 << 0
/*! \qmlproperty int BCW::QSPI0_DISABLED
    \brief Boot Config Word bits for disabling boot on QSPI0. */
var QSPI0_DISABLED      = 3 << 0

var QSPI1_MASK          = 3 << 2
/*! \qmlproperty int BCW::QSPI1_IOSET1
    \brief Boot Config Word bits for booting on QSPI1 I/O set 1. */
var QSPI1_IOSET1        = 0 << 2
/*! \qmlproperty int BCW::QSPI1_IOSET2
    \brief Boot Config Word bits for booting on QSPI1 I/O set 2. */
var QSPI1_IOSET2        = 1 << 2
/*! \qmlproperty int BCW::QSPI1_IOSET3
    \brief Boot Config Word bits for booting on QSPI1 I/O set 3. */
var QSPI1_IOSET3        = 2 << 2
/*! \qmlproperty int BCW::QSPI1_DISABLED
    \brief Boot Config Word bits for disabling boot on QSPI1. */
var QSPI1_DISABLED      = 3 << 2

var SPI0_MASK           = 3 << 4
/*! \qmlproperty int BCW::SPI0_IOSET1
    \brief Boot Config Word bits for booting on SPI0 I/O set 1. */
var SPI0_IOSET1         = 0 << 4
/*! \qmlproperty int BCW::SPI0_IOSET2
    \brief Boot Config Word bits for booting on SPI0 I/O set 2. */
var SPI0_IOSET2         = 1 << 4
/*! \qmlproperty int BCW::SPI0_DISABLED
    \brief Boot Config Word bits for disabling boot on SPI0. */
var SPI0_DISABLED       = 3 << 4

var SPI1_MASK           = 3 << 6
/*! \qmlproperty int BCW::SPI1_IOSET1
    \brief Boot Config Word bits for booting on SPI1 I/O set 1. */
var SPI1_IOSET1         = 0 << 6
/*! \qmlproperty int BCW::SPI1_IOSET2
    \brief Boot Config Word bits for booting on SPI1 I/O set 2. */
var SPI1_IOSET2         = 1 << 6
/*! \qmlproperty int BCW::SPI1_IOSET3
    \brief Boot Config Word bits for booting on SPI1 I/O set 3. */
var SPI1_IOSET3         = 2 << 6
/*! \qmlproperty int BCW::SPI1_DISABLED
    \brief Boot Config Word bits for disabling boot on SPI1. */
var SPI1_DISABLED       = 3 << 6

var NFC_MASK            = 3 << 8
/*! \qmlproperty int BCW::NFC_IOSET1
    \brief Boot Config Word bits for booting on NFC I/O set 1. */
var NFC_IOSET1          = 0 << 8
/*! \qmlproperty int BCW::NFC_IOSET2
    \brief Boot Config Word bits for booting on NFC I/O set 2. */
var NFC_IOSET2          = 1 << 8
/*! \qmlproperty int BCW::NFC_DISABLED
    \brief Boot Config Word bits for disabling boot on NFC. */
var NFC_DISABLED        = 3 << 8

/*! \qmlproperty int BCW::SDMMC0_DISABLED
    \brief Boot Config Word bits for disabling boot on SDMMC0. */
var SDMMC0_DISABLED     = 1 << 10

/*! \qmlproperty int BCW::SDMMC1_DISABLED
    \brief Boot Config Word bits for disabling boot on SDMMC1. */
var SDMMC1_DISABLED     = 1 << 11

var UART_MASK           = 15 << 12
/*! \qmlproperty int BCW::UART1_IOSET1
    \brief Boot Config Word bits for setting CONSOLE on UART1 I/O set 1. */
var UART1_IOSET1        = 0 << 12
/*! \qmlproperty int BCW::UART0_IOSET1
    \brief Boot Config Word bits for setting CONSOLE on UART0 I/O set 1. */
var UART0_IOSET1        = 1 << 12
/*! \qmlproperty int BCW::UART1_IOSET2
    \brief Boot Config Word bits for setting CONSOLE on UART1 I/O set 2. */
var UART1_IOSET2        = 2 << 12
/*! \qmlproperty int BCW::UART2_IOSET1
    \brief Boot Config Word bits for setting CONSOLE on UART2 I/O set 1. */
var UART2_IOSET1        = 3 << 12
/*! \qmlproperty int BCW::UART2_IOSET2
    \brief Boot Config Word bits for setting CONSOLE on UART2 I/O set 2. */
var UART2_IOSET2        = 4 << 12
/*! \qmlproperty int BCW::UART2_IOSET3
    \brief Boot Config Word bits for setting CONSOLE on UART2 I/O set 3. */
var UART2_IOSET3        = 5 << 12
/*! \qmlproperty int BCW::UART3_IOSET1
    \brief Boot Config Word bits for setting CONSOLE on UART3 I/O set 1. */
var UART3_IOSET1        = 6 << 12
/*! \qmlproperty int BCW::UART3_IOSET2
    \brief Boot Config Word bits for setting CONSOLE on UART3 I/O set 2. */
var UART3_IOSET2        = 7 << 12
/*! \qmlproperty int BCW::UART3_IOSET3
    \brief Boot Config Word bits for setting CONSOLE on UART3 I/O set 3. */
var UART3_IOSET3        = 8 << 12
/*! \qmlproperty int BCW::UART4_IOSET1
    \brief Boot Config Word bits for setting CONSOLE on UART4 I/O set 1. */
var UART4_IOSET1        = 9 << 12
/*! \qmlproperty int BCW::UART_DISABLED
    \brief Boot Config Word bits for disabling CONSOLE. */
var UART_DISABLED       = 15 << 12

var JTAG_MASK           = 3 << 16
/*! \qmlproperty int BCW::JTAG_IOSET1
    \brief Boot Config Word bits for setting JTAG on I/O set 1. */
var JTAG_IOSET1         = 0 << 16
/*! \qmlproperty int BCW::JTAG_IOSET2
    \brief Boot Config Word bits for setting JTAG on I/O set 2. */
var JTAG_IOSET2         = 1 << 16
/*! \qmlproperty int BCW::JTAG_IOSET3
    \brief Boot Config Word bits for setting JTAG on I/O set 3. */
var JTAG_IOSET3         = 2 << 16
/*! \qmlproperty int BCW::JTAG_IOSET4
    \brief Boot Config Word bits for setting JTAG on I/O set 4. */
var JTAG_IOSET4         = 3 << 16

/*! \qmlproperty int BCW::EXT_MEM_BOOT
    \brief Boot Config Word bits for enabling boot on external memories. */
var EXT_MEM_BOOT = 1 << 18

/*! \qmlproperty int BCW::QSPI_XIP_MODE
    \brief Boot Config Word bits for enabling XIP mode on QSPI Flash. */
var QSPI_XIP_MODE       = 1 << 21

/*! \qmlproperty int BCW::DISABLE_BSCR
    \brief Boot Config Word bits for disabling read of BSCR register.

    Only valid if boot configuration word is written in fuses, not for GPBR.
 */
var DISABLE_BSCR        = 1 << 22

/*! \qmlproperty int BCW::DISABLE_MONITOR
    \brief Boot Config Word bits for disabling SAM-BA Monitor. */
var DISABLE_MONITOR     = 1 << 24

/*! \qmlproperty int BCW::SECURE_MODE
    \brief Boot Config Word bits for enabling Secure Mode. */
var SECURE_MODE         = 1 << 29

/*!
	\qmlmethod string BCW::toText(int value)
	Converts a boot config word \a value to text for user display.
*/
function toText(value) {
	var text = []

	switch (value & QSPI0_MASK) {
	case QSPI0_IOSET1:
		text.push("QSPI0_IOSET1")
		break
	case QSPI0_IOSET2:
		text.push("QSPI0_IOSET2")
		break
	case QSPI0_IOSET3:
		text.push("QSPI0_IOSET3")
		break
	default:
		text.push("QSPI0_DISABLED")
		break
	}

	switch (value & QSPI1_MASK) {
	case QSPI1_IOSET1:
		text.push("QSPI1_IOSET1")
		break
	case QSPI1_IOSET2:
		text.push("QSPI1_IOSET2")
		break
	case QSPI1_IOSET3:
		text.push("QSPI1_IOSET3")
		break
	default:
		text.push("QSPI1_DISABLED")
		break
	}

	switch (value & SPI0_MASK) {
	case SPI0_IOSET1:
		text.push("SPI0_IOSET1")
		break
	case SPI0_IOSET2:
		text.push("SPI0_IOSET2")
		break
	default:
		text.push("SPI0_DISABLED")
		break
	}

	switch (value & SPI1_MASK) {
	case SPI1_IOSET1:
		text.push("SPI1_IOSET1")
		break
	case SPI1_IOSET2:
		text.push("SPI1_IOSET2")
		break
	case SPI1_IOSET3:
		text.push("SPI1_IOSET3")
		break
	default:
		text.push("SPI1_DISABLED")
		break
	}

	switch (value & NFC_MASK) {
	case NFC_IOSET1:
		text.push("NFC_IOSET1")
		break
	case NFC_IOSET2:
		text.push("NFC_IOSET2")
		break
	default:
		text.push("NFC_DISABLED")
		break
	}

	if (value & SDMMC0_DISABLED)
		text.push("SDMMC0_DISABLED")
	else
		text.push("SDMMC0")

	if (value & SDMMC1_DISABLED)
		text.push("SDMMC1_DISABLED")
	else
		text.push("SDMMC1")

	switch (value & UART_MASK) {
	case UART1_IOSET1:
		text.push("UART1_IOSET1")
		break
	case UART0_IOSET1:
		text.push("UART0_IOSET1")
		break
	case UART1_IOSET2:
		text.push("UART1_IOSET2")
		break
	case UART2_IOSET1:
		text.push("UART2_IOSET1")
		break
	case UART2_IOSET2:
		text.push("UART2_IOSET2")
		break
	case UART2_IOSET3:
		text.push("UART2_IOSET3")
		break
	case UART3_IOSET1:
		text.push("UART3_IOSET1")
		break
	case UART3_IOSET2:
		text.push("UART3_IOSET2")
		break
	case UART3_IOSET3:
		text.push("UART3_IOSET3")
		break
	case UART4_IOSET1:
		text.push("UART4_IOSET1")
		break
	default:
		text.push("UART_DISABLED")
		break
	}

	switch (value & JTAG_MASK) {
	case JTAG_IOSET1:
		text.push("JTAG_IOSET1")
		break
	case JTAG_IOSET2:
		text.push("JTAG_IOSET2")
		break
	case JTAG_IOSET3:
		text.push("JTAG_IOSET3")
		break
	case JTAG_IOSET4:
		text.push("JTAG_IOSET4")
		break
	}

	if (value & EXT_MEM_BOOT)
		text.push("EXT_MEM_BOOT")

	if (value & QSPI_XIP_MODE)
		text.push("QSPI_XIP_MODE")

	if (value & DISABLE_BSCR)
		text.push("DISABLE_BSCR")

	if (value & DISABLE_MONITOR)
		text.push("DISABLE_MONITOR")

	if (value & SECURE_MODE)
		text.push("SECURE_MODE")

	return text.join(",")
}

/*!
	\qmlmethod int BCW::fromText(string text)
	Converts a string to a boot config word \a value.
*/
function fromText(text) {
	var entries = text.split(',')
	var names = ["QSPI0_IOSET1", "QSPI0_IOSET2",
	             "QSPI0_IOSET3", "QSPI0_DISABLED",
	             "QSPI1_IOSET1", "QSPI1_IOSET2",
	             "QSPI1_IOSET3", "QSPI1_DISABLED",
	             "SPI0_IOSET1", "SPI0_IOSET2", "SPI0_DISABLED",
	             "SPI1_IOSET1", "SPI1_IOSET2",
	             "SPI1_IOSET3", "SPI1_DISABLED",
	             "NFC_IOSET1", "NFC_IOSET2", "NFC_DISABLED",
	             "SDMMC0_DISABLED", "SDMMC0",
	             "SDMMC1_DISABLED", "SDMMC1",
	             "UART1_IOSET1", "UART0_IOSET1", "UART1_IOSET2",
	             "UART2_IOSET1", "UART2_IOSET2", "UART2_IOSET3",
	             "UART3_IOSET1", "UART3_IOSET2", "UART3_IOSET3",
	             "UART4_IOSET1", "UART_DISABLED",
	             "JTAG_IOSET1", "JTAG_IOSET2",
	             "JTAG_IOSET3", "JTAG_IOSET4",
	             "EXT_MEM_BOOT",
	             "QSPI_XIP_MODE",
	             "DISABLE_BSCR",
	             "DISABLE_MONITOR",
	             "SECURE_MODE"]
	var values = [QSPI0_IOSET1, QSPI0_IOSET2,
	              QSPI0_IOSET3, QSPI0_DISABLED,
	              QSPI1_IOSET1, QSPI1_IOSET2,
	              QSPI1_IOSET3, QSPI1_DISABLED,
	              SPI0_IOSET1, SPI0_IOSET2, SPI0_DISABLED,
	              SPI1_IOSET1, SPI1_IOSET2,
	              SPI1_IOSET3, SPI1_DISABLED,
	              NFC_IOSET1, NFC_IOSET2, NFC_DISABLED,
	              SDMMC0_DISABLED, 0,
	              SDMMC1_DISABLED, 0,
	              UART1_IOSET1, UART0_IOSET1, UART1_IOSET2,
	              UART2_IOSET1, UART2_IOSET2, UART2_IOSET3,
	              UART3_IOSET1, UART3_IOSET2, UART3_IOSET3,
	              UART4_IOSET1, UART_DISABLED,
	              JTAG_IOSET1, JTAG_IOSET2,
	              JTAG_IOSET3, JTAG_IOSET4,
	              EXT_MEM_BOOT,
	              QSPI_XIP_MODE,
	              DISABLE_BSCR,
	              DISABLE_MONITOR,
	              SECURE_MODE]
	var bcw = 0
	for (var i = 0; i < entries.length; i++) {
		var index = names.indexOf(entries[i].toUpperCase())
		if (index < 0)
			throw new Error("Invalid BCW value '" + entries[i] + "'")
		bcw |= values[index]
	}
	return bcw
}
