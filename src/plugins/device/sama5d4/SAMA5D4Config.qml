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
	\qmltype SAMA5D4Config
	\inqmlmodule SAMBA.Device.SAMA5D4
	\brief Contains configuration values for a SAMA5D4 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin
	\row    \li 0        \li DBGU       \li 1       \li PB25A
	\row    \li 1        \li UART0      \li 1       \li PE30B
	\row    \li 2        \li UART1      \li 1       \li PC26C
	\row    \li 3        \li USART0     \li 1       \li PD13A
	\row    \li 4        \li USART1     \li 1       \li PD17A
	\row    \li 5        \li USART2     \li 1       \li PB5B
	\row    \li 6        \li USART3     \li 1       \li PE17B
	\row    \li 7        \li USART4     \li 1       \li PE27B
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
	\header \li Instance \li Peripheral      \li I/O Set \li Bus Width
	\row    \li 0        \li HSMCI0 (Slot A) \li 1       \li 1-bit, 4-bit, 8-bit
	\row    \li 0        \li HSMCI0 (Slot B) \li 2       \li 1-bit, 4-bit
	\row    \li 1        \li HSMCI1          \li 1       \li 1-bit, 4-bit
	\endtable

	The SD/MMC applet on SAMA5D4 does not support voltage switching, so the
	\a voltage configuration property is ignored.

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC4B  \li Clock
	\row    \li PC5B  \li Command
	\row    \li PC6B  \li Data 0 (bus width: 1-bit, 4-bit, 8-bit)
	\row    \li PC7B  \li Data 1 (bus width: 4-bit, 8-bit)
	\row    \li PC8B  \li Data 2 (bus width: 4-bit, 8-bit)
	\row    \li PC9B  \li Data 3 (bus width: 4-bit, 8-bit)
	\row    \li PC10B \li Data 4 (bus width: 8-bit)
	\row    \li PC11B \li Data 5 (bus width: 8-bit)
	\row    \li PC12B \li Data 6 (bus width: 8-bit)
	\row    \li PC13B \li Data 7 (bus width: 8-bit)
	\endtable

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PC4B  \li Clock
	\row    \li PE0B  \li Command
	\row    \li PE1B  \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PE2B  \li Data 1 (bus width: 4-bit)
	\row    \li PE3B  \li Data 2 (bus width: 4-bit)
	\row    \li PE4B  \li Data 3 (bus width: 4-bit)
	\endtable

	\section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

	\table
	\header \li Pin  \li Use
	\row    \li PE18C \li Clock
	\row    \li PE19C \li Command
	\row    \li PE20C \li Data 0 (Bus Width: 1-bit, 4-bit)
	\row    \li PE21C \li Data 1 (Bus Width: 4-bit)
	\row    \li PE22C \li Data 2 (Bus Width: 4-bit)
	\row    \li PE23C \li Data 3 (Bus Width: 4-bit)
	\endtable

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
