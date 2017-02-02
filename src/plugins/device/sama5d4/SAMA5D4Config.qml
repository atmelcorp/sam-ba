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
	\qmltype SAMA5D4Config
	\inqmlmodule SAMBA.Device.SAMA5D4
	\brief Contains configuration values for a SAMA5D4 device.

	By default, no configuration values are set.

	\section1 SPI Serial Flash Configuration

	The following SPI Serial Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Chip Selects
	\row    \li 0        \li SPI0       \li 1       \li 0, 1, 2, 3
	\row    \li 0        \li SPI0       \li 2       \li 1, 2
	\row    \li 1        \li SPI1       \li 1       \li 0, 1, 2, 3
	\row    \li 1        \li SPI1       \li 2       \li 1, 2, 3
	\row    \li 2        \li SPI2       \li 1       \li 0, 1, 2, 3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC0A  \li MISO
	\row    \li PC1A  \li MOSI
	\row    \li PC2A  \li SPCK
	\row    \li PC3A  \li NPCS0
	\row    \li PC4A  \li NPCS1
	\row    \li PC28B \li NPCS2
	\row    \li PC29B \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PC0A  \li MISO
	\row    \li PC1A  \li MOSI
	\row    \li PC2A  \li SPCK
	\row    \li PC27B \li NPCS1
	\row    \li PD31A \li NPCS2
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PB18A \li MISO
	\row    \li PB19A \li MOSI
	\row    \li PB20A \li SPCK
	\row    \li PB21A \li NPCS0
	\row    \li PA26C \li NPCS1
	\row    \li PA27C \li NPCS2
	\row    \li PA28C \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PB18A \li MISO
	\row    \li PB19A \li MOSI
	\row    \li PB20A \li SPCK
	\row    \li PB22A \li NPCS1
	\row    \li PB23A \li NPCS2
	\row    \li PB27A \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 2 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PD11B \li MISO
	\row    \li PD13B \li MOSI
	\row    \li PD15B \li SPCK
	\row    \li PD17B \li NPCS0
	\row    \li PB14B \li NPCS1
	\row    \li PB15B \li NPCS2
	\row    \li PB28A \li NPCS3
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
	\row    \li PC13A \li NANDOE  \li 8-bit, 16-bit
	\row    \li PC14A \li NANDWE  \li 8-bit, 16-bit
	\row    \li PC15A \li NCS3    \li 8-bit, 16-bit
	\row    \li PC16A \li NANDRDY \li 8-bit, 16-bit
	\row    \li PC17A \li NANDALE \li 8-bit, 16-bit
	\row    \li PC18A \li NANDCLE \li 8-bit, 16-bit
	\row    \li PC5A  \li D0      \li 8-bit, 16-bit
	\row    \li PC6A  \li D1      \li 8-bit, 16-bit
	\row    \li PC7A  \li D2      \li 8-bit, 16-bit
	\row    \li PC8A  \li D3      \li 8-bit, 16-bit
	\row    \li PC9A  \li D4      \li 8-bit, 16-bit
	\row    \li PC10A \li D5      \li 8-bit, 16-bit
	\row    \li PC11A \li D6      \li 8-bit, 16-bit
	\row    \li PC12A \li D7      \li 8-bit, 16-bit
	\row    \li PB18B \li D8      \li 16-bit
	\row    \li PB19B \li D9      \li 16-bit
	\row    \li PB20B \li D10     \li 16-bit
	\row    \li PB21B \li D11     \li 16-bit
	\row    \li PB22B \li D12     \li 16-bit
	\row    \li PB23B \li D13     \li 16-bit
	\row    \li PB24B \li D14     \li 16-bit
	\row    \li PB25B \li D15     \li 16-bit
	\endtable
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
