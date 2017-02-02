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
	\qmltype NANDFlashConfig
	\inqmlmodule SAMBA.Applet
	\brief Contains configuration values for the NAND Flash applet.
*/
Item {
	/*! NAND I/O set */
	property var ioset

	/*! NAND Bus Width, in bits (8/16) */
	property var busWidth

	/*! NAND Header */
	property var header
}
