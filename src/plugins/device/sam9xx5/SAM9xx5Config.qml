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
	\qmltype SAM9xx5Config
	\inqmlmodule SAMBA.Device.SAM9xx5
	\brief Contains configuration values for a SAM9xx5 device.

	By default, no configuration values are set.

	\section1 DDRAM

	The following DDRAM configurations are supported:

	\table
	\header \li Preset \li Type \li Model \li Size
	\row \li 0 \li DDR2 \li MT47H128M8 \li 4x128MB
	\row \li 1 \li DDR2 \li MT47H64M16 \li 128MB
	\row \li 2 \li DDR2 \li MT47H128M16 \li 2x256MB
	\row \li 3 \li LPDDR2 \li MT42L128M16 \li 2x256MB
	\endtable

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
	\row    \li PA11A \li MISO
	\row    \li PA12A \li MOSI
	\row    \li PA13A \li SPCK
	\row    \li PA14A \li NPCS0
	\row    \li PA7B  \li NPCS1
	\row    \li PA1B  \li NPCS2
	\row    \li PB3B  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA21B \li MISO
	\row    \li PA22B \li MOSI
	\row    \li PA23B \li SPCK
	\row    \li PA8B  \li NPCS0
	\row    \li PA0B  \li NPCS1
	\row    \li PA31B \li NPCS2
	\row    \li PA30B \li NPCS3
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
	\row    \li PD0A  \li NANDOE  \li 8-bit, 16-bit
	\row    \li PD1A  \li NANDWE  \li 8-bit, 16-bit
	\row    \li PD4A  \li NCS3    \li 8-bit, 16-bit
	\row    \li PD2A  \li NANDALE \li 8-bit, 16-bit
	\row    \li PD3A  \li NANDCLE \li 8-bit, 16-bit
	\row    \li PD6A  \li D16     \li 8-bit, 16-bit
	\row    \li PD7A  \li D17     \li 8-bit, 16-bit
	\row    \li PD8A  \li D18     \li 8-bit, 16-bit
	\row    \li PD9A  \li D19     \li 8-bit, 16-bit
	\row    \li PD10A \li D20     \li 8-bit, 16-bit
	\row    \li PD11A \li D21     \li 8-bit, 16-bit
	\row    \li PD12A \li D22     \li 8-bit, 16-bit
	\row    \li PD13A \li D23     \li 8-bit, 16-bit
	\row    \li PD14A \li D24     \li 16-bit
	\row    \li PD15A \li D25     \li 16-bit
	\row    \li PD16A \li D26     \li 16-bit
	\row    \li PD17A \li D27     \li 16-bit
	\row    \li PD18A \li D28     \li 16-bit
	\row    \li PD19A \li D29     \li 16-bit
	\row    \li PD20A \li D30     \li 16-bit
	\row    \li PD21A \li D31     \li 16-bit
	\endtable

	For I/O Set 1, the NAND Flash applet enables NFD0_ON_D16 in Bus Matrix
	CCFG_EBICSA register.  This maps SMC D16-D31 pins to NAND D0-D15.
*/
Item {
	/*!
		\brief Configuration for DDRAM applet

		See \l{SAMBA.Applet::}{ExtRamConfig} for a list of configurable properties.
        */
	property alias extram: extram
	ExtRamConfig {
		id: extram
	}

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
