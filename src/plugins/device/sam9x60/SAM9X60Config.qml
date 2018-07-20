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
import SAMBA.Applet 3.2
import SAMBA.Device.SAM9X60 3.2

/*!
	\qmltype SAM9X60Config
	\inqmlmodule SAMBA.Device.SAM9X60
	\brief Contains configuration values for a SAM9X60 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin
	\row    \li 0        \li DBGU       \li 1       \li PA10A
	\row    \li 1        \li FLEXCOM0   \li 1       \li PA0A
	\row    \li 2        \li FLEXCOM1   \li 1       \li PA5A
	\row    \li 3        \li FLEXCOM2   \li 1       \li PA7A
	\row    \li 4        \li FLEXCOM3   \li 1       \li PC22B
	\row    \li 5        \li FLEXCOM4   \li 1       \li PA12A
	\row    \li 6        \li FLEXCOM5   \li 1       \li PA22B
	\row    \li 7        \li FLEXCOM6   \li 1       \li PA30A
	\row    \li 8        \li FLEXCOM7   \li 1       \li PC0C
	\row    \li 9        \li FLEXCOM8   \li 1       \li PB4B
	\row    \li 10       \li FLEXCOM9   \li 1       \li PC8C
	\row    \li 11       \li FLEXCOM10  \li 1       \li PC16C
	\row    \li 12       \li FLEXCOM11  \li 1       \li PB19C
	\row    \li 13       \li FLEXCOM12  \li 1       \li PB21C
	\endtable

	\section1 External RAM

	The following external RAM configurations are supported:

	\table
	\header \li Preset \li Type   \li Model       \li Size
	\endtable

	\section1 SD/MMC Configuration

	The following SD/MMC configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Bus Width
	\row    \li 0        \li SDMMC0     \li 1       \li 1-bit, 4-bit
	\row    \li 1        \li SDMMC1     \li 1       \li 1-bit, 4-bit
	\endtable

	The SD/MMC applet on SAM9X60 does not support voltage switching, so the
	\a voltage configuration property is ignored.

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA17A \li Clock
	\row    \li PA16A \li Command
	\row    \li PA15A \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PA18A \li Data 1 (bus width: 4-bit)
	\row    \li PA19A \li Data 2 (bus width: 4-bit)
	\row    \li PA20A \li Data 4 (bus width: 4-bit)
	\endtable

	\section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA13B \li Clock
	\row    \li PA12B \li Command
	\row    \li PA11B \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PA2B  \li Data 1 (bus width: 4-bit)
	\row    \li PA3B  \li Data 2 (bus width: 4-bit)
	\row    \li PA4B  \li Data 3 (bus width: 4-bit)
	\endtable

	\section1 SPI Serial Flash Configuration

	The following SPI Serial Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Chip Selects
	\row    \li 0        \li FLEXCOM0   \li 1       \li 0, 1
	\row    \li 1        \li FLEXCOM1   \li 1       \li 0, 1
	\row    \li 2        \li FLEXCOM2   \li 1       \li 0, 1
	\row    \li 3        \li FLEXCOM3   \li 1       \li 0, 1
	\row    \li 4        \li FLEXCOM4   \li 1       \li 0, 1, 2, 3
	\row    \li 4        \li FLEXCOM4   \li 2       \li 0, 1, 2, 3
	\row    \li 5        \li FLEXCOM5   \li 1       \li 0, 1, 2, 3
	\row    \li 5        \li FLEXCOM5   \li 2       \li 0, 1, 2, 3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA0A  \li MOSI
	\row    \li PA1A  \li MISO
	\row    \li PA4A  \li SPCK
	\row    \li PA3A  \li NPCS0
	\row    \li PA2A  \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA5A  \li MOSI
	\row    \li PA6A  \li MISO
	\row    \li PC29C \li SPCK
	\row    \li PC28C \li NPCS0
	\row    \li PC27C \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 2 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA7A  \li MOSI
	\row    \li PA8A  \li MISO
	\row    \li PB2B  \li SPCK
	\row    \li PB1B  \li NPCS0
	\row    \li PB0B  \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 3 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC22B \li MOSI
	\row    \li PC23B \li MISO
	\row    \li PC26B \li SPCK
	\row    \li PC25B \li NPCS0
	\row    \li PC24B \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 4 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA12A \li MOSI
	\row    \li PA11A \li MISO
	\row    \li PA13A \li SPCK
	\row    \li PA14A \li NPCS0
	\row    \li PA0C  \li NPCS1
	\row	\li PA1B  \li NPCS2
	\row    \li PB3B  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 4 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PA12A \li MOSI
	\row    \li PA11A \li MISO
	\row    \li PA13A \li SPCK
	\row    \li PA14A \li NPCS0
	\row    \li PA7B  \li NPCS1
        \row    \li PA8C  \li NPCS2
	\row    \li PB3B  \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA22B \li MOSI
	\row    \li PA21B \li MISO
	\row    \li PA23B \li SPCK
	\row    \li PA8B  \li NPCS0
	\row    \li PA0B  \li NPCS1
        \row    \li PA31B \li NPCS2
	\row    \li PA30B \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PA22B \li MOSI
	\row    \li PA21B \li MISO
	\row    \li PA23B \li SPCK
	\row    \li PA8B  \li NPCS0
	\row    \li PA7C  \li NPCS1
        \row    \li PA31B \li NPCS2
	\row    \li PA30B \li NPCS3
	\endtable
	
	\section1 QSPI Flash Configuration

	The following QSPI Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set
	\row    \li 0        \li QSPI0      \li 1
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PB19A \li SCK
	\row    \li PB20A \li CS
	\row    \li PB21A \li IO0
	\row    \li PB22A \li IO1
	\row    \li PB23A \li IO2
	\row    \li PB24A \li IO3
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
	\row    \li PD2A  \li NANDALE \li 8-bit, 16-bit
	\row    \li PD3A  \li NANDCLE \li 8-bit, 16-bit
	\row    \li PD4A  \li NCS3    \li 8-bit, 16-bit
	\row    \li PD5A  \li NWAIT   \li 8-bit, 16-bit
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
		\brief Configuraiton for Low Level applet

		see \l{SAMBA.Device.SAM9X60::}{SAM9X60LowlevelConfig} for a list if configurable properties.
	*/
	property alias lowlevel: lowlevel
	SAM9X60LowlevelConfig {
		id: lowlevel
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

	/*!
		\brief Configuration for QSPI Flash applet

		See \l{SAMBA.Applet::}{QSPIFlashConfig} for a list of configurable properties.
        */
	property alias qspiflash: qspiflash
	QSPIFlashConfig {
		id: qspiflash
	}
}
