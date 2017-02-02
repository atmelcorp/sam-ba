/*
 * Copyright (c) 2015-2017, Atmel Corporation.
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
import SAMBA.Applet 3.1

/*!
	\qmltype SAMA5D3Config
	\inqmlmodule SAMBA.Device.SAMA5D3
	\brief Contains configuration values for a SAMA5D3 device.

	By default, no configuration values are set.

	\section1 SPI Serial Flash Configuration

	The following SPI Serial Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Chip Selects
	\row    \li 0        \li SPI0       \li 1       \li 0, 1, 2, 3
	\row    \li 1        \li SPI1       \li 1       \li 0, 1, 2, 3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PD10A \li MISO
	\row    \li PD11A \li MOSI
	\row    \li PD12A \li SPCK
	\row    \li PD13A \li NPCS0
	\row    \li PD14B \li NPCS1
	\row    \li PD15B \li NPCS2
	\row    \li PD16B \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC22A \li MISO
	\row    \li PC23A \li MOSI
	\row    \li PC24A \li SPCK
	\row    \li PC25A \li NPCS0
	\row    \li PC26A \li NPCS1
	\row    \li PC27A \li NPCS2
	\row    \li PC28A \li NPCS3
	\endtable

	\section1 NAND Flash Configuration

	The following NAND Flash configurations are supported:

	\table
	\header \li I/O Set \li Bus Width
	\row    \li 1       \li 8-bit, 16-bit
	\endtable

	\section2 Pin List for NAND Flash (I/O Set 1)

	\table
	\header \li Pin   \li Use     \li Bus Width
	\row    \li PE21A \li NANDALE \li 8-bit, 16-bit
	\row    \li PE22A \li NANDCLE \li 8-bit, 16-bit
	\endtable

	Other NAND pins are not muxed by the PIO controller.
*/
Item {
	/*!
		\brief Configuration for SPI Serial Flash applet

		See \l{SAMBA.Applet::}{SerialFlashConfig} for a list of configurable properties.
        */
	property alias serialflash: serialflash
	SerialFlashConfig {
		id: serialflash
	}

	/*!
		\brief Configuration for NAND Flash applet

		See \l{SAMBA.Applet::}{NANDFlashConfig} for a list of configurable properties.
        */
	property alias nandflash: nandflash
	NANDFlashConfig {
		id: nandflash
	}
}
