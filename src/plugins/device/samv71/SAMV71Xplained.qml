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
	\qmltype SAMV71Xplained
	\inqmlmodule SAMBA.Device.SAMV71
	\brief Contains a specialization of the SAMV71 QML type for the
	       SAMV71 Xplained Ultra board.
*/
SAMV71 {
	name: "samv71-xplained"

	aliases: [ "samv71-xult" ]

	description: "SAMV71 Xplained Ultra"

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
