/*
 * Copyright (c) 2017, Atmel Corporation.
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

/*!
	\qmltype SDMMCConfig
	\inqmlmodule SAMBA.Applet
	\brief Contains configuration values for the SD/MMC applet.
*/
Item {
	/*! SD/MMC peripheral instance */
	property var instance

	/*! SD/MMC I/O set */
	property var ioset

	/*! SD/MMC partition (0=default, x>0=boot partition x) */
	property var partition

	/*! SD/MMC bus width (0=automatic, 1=1-bit, 4=4-bit, 8=8-bit) */
	property var busWidth

	/*! SD/MMC voltage support (bitfield: 1=1.8V, 2=3.0V, 3=3.3V) */
	property var voltages
}
