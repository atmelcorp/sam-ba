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
	\qmltype QSPIFlashConfig
	\inqmlmodule SAMBA.Applet
	\brief Contains configuration values for the QSPI Flash applet.
*/
Item {
	/*! QuadSPI peripheral instance */
	property var instance

	/*! QuadSPI I/O set */
	property var ioset

	/*! QuadSPI frequency, in MHz */
	property var freq
}
