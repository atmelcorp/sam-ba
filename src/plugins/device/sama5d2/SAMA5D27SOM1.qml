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
import SAMBA.Device.SAMA5D2 3.2

/*!
	\qmltype SAMA5D27SOM1
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains a specialization of the SAMA5D2 QML type for the
	       SAMA5D27-SOM1 System on Module.
*/
SAMA5D2 {
	name: "sama5d27-som1"

	aliases: []

	description: "SAMA5D27-SOM1 System on Module"

	config {
		// No default serial console
		serial {
		}

		// W971G16SG
		extram {
			preset: 8
		}

		// No SDMMC on this board
		sdmmc {
		}

		// No SerialFlash on this board
		serialflash {
		}

		// No NAND on this board
		nandflash {
		}

		// QSPI1, I/O Set 2, 66MHz
		qspiflash {
			instance: 1
			ioset: 2
			freq: 66
		}
	}
}
