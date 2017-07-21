/*
 * Copyright (c) 2016, Atmel Corporation.
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
import SAMBA.Device.SAM9xx5 3.2

/*!
	\qmltype SAM9xx5EK
	\inqmlmodule SAMBA.Device.SAM9xx5
	\brief Contains a specialization of the SAM9xx5 QML type for the
	       AT91SAM9x5-EK board.
*/
SAM9xx5 {
	name: "sam9xx5-ek"

	aliases: [ "sam9g15-ek", "sam9g25-ek", "sam9g35-ek",
	           "sam9x25-ek", "sam9x35-ek" ]

	description: "SAM9xx5-EK"

	config {
		serial {
			instance: 0 /* DBGU */
			ioset: 1
		}

		// MT47H64M16
		extram {
			preset: 1
		}

		sdmmc {
			instance: 1
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

		serialflash {
			instance: 0
			ioset: 1
			chipSelect: 0
			freq: 66
		}

		nandflash {
			ioset: 1
			busWidth: 16
			header: 0xc0c00405
		}
	}
}
