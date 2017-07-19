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
	\qmltype SAMA5D2PTCEK
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains a specialization of the SAMA5D2 QML type for the
	       SAMA5D2-PTC-EK board.
*/
SAMA5D2 {
	name: "sama5d2-ptc-ek"

	aliases: []

	description: "SAMA5D2-PTC-EK"

	config {
		serial {
			instance: 2 /* UART2 */
			ioset: 2
		}

		// W972GG6KB
		extram {
			preset: 9
		}

		// SDCARD: SDMMC0, I/O Set 1, User Partition, Automatic bus width, 1.8V/3.3V switch supported
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

		// MT29F4G08ABA
		nandflash {
			ioset: 1
			busWidth: 8
			header: 0xc1e04e07
		}

		// QSPI0, I/O Set 3, 66MHz
		qspiflash {
			instance: 0
			ioset: 3
			freq: 66
		}
	}
}
