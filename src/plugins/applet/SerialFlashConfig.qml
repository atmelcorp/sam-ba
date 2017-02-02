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
	\qmltype SerialFlashConfig
	\inqmlmodule SAMBA.Applet
	\brief Contains configuration values for the SPI Serial Flash applet.
*/
Item {
	/*! SPI peripheral instance */
	property var instance

	/*! I/O set */
	property var ioset

	/*! Chip Select */
	property var chipSelect

	/*! Bus frequency, in MHz */
	property var freq
}
