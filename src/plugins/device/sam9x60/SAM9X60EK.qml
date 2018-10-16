/*
 * Copyright (c) 2018, Microchip.
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
import SAMBA.Device.SAM9X60 3.2

/*!
	\qmltype SAM9X60EK
	\inqmlmodule SAMBA.Device.SAM9X60
	\brief Contains a specialization of the SAM9X60 QML type for the
	       SAM9X60 Evaluation Kit.
*/
SAM9X60 {
	name: "sam9x60-ek"

	aliases: []

	description: "SAM9X60 Evaluation Kit"

	config {
		serial {
			instance: 0 /* DBGU */
			ioset: 1
		}

		// PCK/MCK = 600/200 MHz
		lowlevel {
			preset: 0
		}

		// W972GG6KB-25
		extram {
			preset: 12
		}

		// SDMMC0, I/O Set 1, User Partition, Automatic bus width, 3.3V
		sdmmc {
			instance: 0
			ioset: 1
			partition: 0
			busWidth: 0
			voltages: 4 /* 3.3V */
		}

		// SPI0, I/O Set 1, NPCS0, 50MHz
		serialflash {
			instance:0
			ioset: 1
			chipSelect: 0
			freq: 50
		}

		// QPSI0, I/O Set 1, 50MHz
		qspiflash {
			instance: 0
			ioset: 1
			freq: 50
		}

		// SMC, I/O Set 1, 8-bit bus width, MT29F4G08ABAEAWP
		nandflash {
			ioset: 1
			busWidth: 8
			header: 0xc1e04e07
		}
	}
}
