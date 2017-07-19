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
	\qmltype SAMA5D27SOM1EK
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains a specialization of the SAMA5D2 QML type for the
	       SAMA5D27-SOM1-EK board.
*/
SAMA5D2 {
	name: "sama5d27-som1-ek"

	aliases: [ "sama5d27-som1-ek1" ]

	description: "SAMA5D27-SOM1-EK"

	config {
		serial {
			instance: 1 /* UART1 */
			ioset: 1
		}

		// W971G16SG
		extram {
			preset: 8
		}

		// eMMC: SDMMC0, I/O Set 1, User Partition, Automatic bus width, 1.8V/3.3V switch supported
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 1 + 4 /* 1.8V + 3.3V */
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
