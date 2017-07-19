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
import SAMBA.Device.SAMV71 3.2

/*!
	\qmltype SAME70Xplained
	\inqmlmodule SAMBA.Device.SAMV71
	\brief Contains a specialization of the SAMV71 QML type for the
	       SAME70 Xplained board.
*/
SAMV71 {
	name: "same70-xplained"

	aliases: []

	description: "SAME70 Xplained"

	config {
		serial {
			instance: 6 /* USART1 */
			ioset: 1
		}

		// IS42S16100E
		extram {
			preset: 6
		}
	}
}
