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
	\qmltype SAMA5D2Xplained
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains a specialization of the SAMA5D2 QML type for the
	       SAMA5D2 Xplained Ultra board.
*/
SAMA5D2 {
	name: "sama5d2-xplained"

	aliases: [ "sama5d2-xult" ]

	description: "SAMA5D2 Xplained Ultra"

	config {
		serial {
			instance: 1 /* UART1 */
			ioset: 1
		}

		// MT41K128M16
		extram {
			preset: 4
		}

		// eMMC: SDMMC0, I/O Set 1, User Partition, Automatic bus width, 1.8V/3.3V switch supported
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 1 + 4 /* 1.8V + 3.3V */
		}

		// SPI0, I/O Set 1, NPCS0, 66MHz
		serialflash {
			instance:0
			ioset: 1
			chipSelect: 0
			freq: 66
		}

		// No NAND on this board
		nandflash {
		}

		// QSPI0, I/O Set 3, 66MHz
		qspiflash {
			instance: 0
			ioset: 3
			freq: 66
		}
	}
}
