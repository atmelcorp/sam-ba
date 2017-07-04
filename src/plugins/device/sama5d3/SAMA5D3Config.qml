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
import SAMBA.Applet 3.2

/*!
	\qmltype SAMA5D3Config
	\inqmlmodule SAMBA.Device.SAMA5D3
	\brief Contains configuration values for a SAMA5D3 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin
	\row    \li 0        \li DBGU       \li 1       \li PB31A
	\row    \li 1        \li UART0      \li 1       \li PC30A
	\row    \li 2        \li UART1      \li 1       \li PA31B
	\row    \li 3        \li USART0     \li 1       \li PD18A
	\row    \li 4        \li USART1     \li 1       \li PB29A
	\row    \li 5        \li USART2     \li 1       \li PE26B
	\row    \li 6        \li USART3     \li 1       \li PE19B
	\endtable

	\section1 External RAM

	The following external RAM configurations are supported:

	\table
	\header \li Preset \li Type   \li Model       \li Size
	\row    \li 0      \li DDR2   \li MT47H128M8  \li 4x128MB
	\row    \li 1      \li DDR2   \li MT47H64M16  \li 128MB
	\row    \li 2      \li DDR2   \li MT47H128M16 \li 2x256MB
	\row    \li 2      \li LPDDR2 \li MT42L128M16 \li 2*256MB
	\row    \li 8      \li DDR2   \li W971G16SG   \li 128MB
	\row    \li 9      \li DDR2   \li W972GG6KB   \li 2*256MB
	\endtable

	\section1 SD/MMC Configuration

	The following SD/MMC configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Bus Width
	\row    \li 0        \li HSMCI0     \li 1       \li 1-bit, 4-bit, 8-bit
	\row    \li 1        \li HSMCI1     \li 1       \li 1-bit, 4-bit
	\row    \li 2        \li HSMCI2     \li 1       \li 1-bit, 4-bit
	\endtable

	The SD/MMC applet on SAMA5D3 does not support voltage switching, so the
	\a voltage configuration property is ignored.

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PD9A  \li Clock
	\row    \li PD0A  \li Command
	\row    \li PD1A  \li Data 0 (bus width: 1-bit, 4-bit, 8-bit)
	\row    \li PD2A  \li Data 1 (bus width: 4-bit, 8-bit)
	\row    \li PD3A  \li Data 2 (bus width: 4-bit, 8-bit)
	\row    \li PD4A  \li Data 3 (bus width: 4-bit, 8-bit)
	\row    \li PD5A \li Data 4 (bus width: 8-bit)
	\row    \li PD6A \li Data 5 (bus width: 8-bit)
	\row    \li PD7A \li Data 6 (bus width: 8-bit)
	\row    \li PD8A \li Data 7 (bus width: 8-bit)
	\endtable

	\section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PB24A \li Clock
	\row    \li PB19A \li Command
	\row    \li PB20A \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PB21A \li Data 1 (bus width: 4-bit)
	\row    \li PB22A \li Data 2 (bus width: 4-bit)
	\row    \li PB23A \li Data 3 (bus width: 4-bit)
	\endtable

	\section2 Pin List for SD/MMC Instance 2 (I/O Set 1)

	\table
	\header \li Pin  \li Use
	\row    \li PC15A \li Clock
	\row    \li PC10A \li Command
	\row    \li PC11A \li Data 0 (Bus Width: 1-bit, 4-bit)
	\row    \li PC12A \li Data 1 (Bus Width: 4-bit)
	\row    \li PC13A \li Data 2 (Bus Width: 4-bit)
	\row    \li PC14A \li Data 3 (Bus Width: 4-bit)
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
		\brief Configuration for applet serial console output

		See \l{SAMBA.Applet::}{SerialConfig} for a list of configurable properties.
        */
	property alias serial: serial
	SerialConfig {
		id: serial
	}

	/*!
		\brief Configuration for external RAM applet

		See \l{SAMBA.Applet::}{ExtRamConfig} for a list of configurable properties.
        */
	property alias extram: extram
	ExtRamConfig {
		id: extram
	}

	/*!
		\brief Configuration for SD/MMC applet

		See \l{SAMBA.Applet::}{SDMMCConfig} for a list of configurable properties.
        */
	property alias sdmmc: sdmmc
	SDMMCConfig {
		id: sdmmc
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
