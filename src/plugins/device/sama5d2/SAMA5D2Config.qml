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
	\qmltype SAMA5D2Config
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains configuration values for a SAMA5D2 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin
	\row    \li 0        \li UART0      \li 1       \li PB27C
	\row    \li 1        \li UART1      \li 1       \li PD3A
	\row    \li 1        \li UART1      \li 2       \li PC8E
	\row    \li 2        \li UART2      \li 1       \li PD5B
	\row    \li 2        \li UART2      \li 2       \li PD24A
	\row    \li 2        \li UART2      \li 3       \li PD20C
	\row    \li 3        \li UART3      \li 1       \li PC13D
	\row    \li 3        \li UART3      \li 2       \li PD0C
	\row    \li 3        \li UART3      \li 3       \li PB12C
	\row    \li 4        \li UART4      \li 1       \li PB4A
	\row    \li 5        \li FLEXCOM0   \li 1       \li PB28C
	\row    \li 6        \li FLEXCOM1   \li 1       \li PA24A
	\row    \li 7        \li FLEXCOM2   \li 1       \li PA6E
	\row    \li 7        \li FLEXCOM2   \li 2       \li PD26C
	\row    \li 8        \li FLEXCOM3   \li 1       \li PA15E
	\row    \li 8        \li FLEXCOM3   \li 2       \li PC20E
	\row    \li 8        \li FLEXCOM3   \li 3       \li PB23E
	\row    \li 9        \li FLEXCOM4   \li 1       \li PC28B
	\row    \li 9        \li FLEXCOM4   \li 2       \li PD12B
	\row    \li 9        \li FLEXCOM4   \li 3       \li PD21C
	\endtable

	\section1 External RAM

	The following external RAM configurations are supported:

	\table
	\header \li Preset \li Type   \li Model       \li Size
	\row    \li 0      \li DDR2   \li MT47H128M8  \li 4x128MB
	\row    \li 1      \li DDR2   \li MT47H64M16  \li 128MB
	\row    \li 2      \li DDR2   \li MT47H128M16 \li 2x256MB
	\row    \li 2      \li LPDDR2 \li MT42L128M16 \li 2*256MB
	\row    \li 4      \li DDR3   \li MT41K128M16 \li 2*256MB
	\row    \li 5      \li LPDDR3 \li EDF8164A3MA \li 2*256MB
	\row    \li 8      \li DDR2   \li W971G16SG   \li 128MB
	\row    \li 9      \li DDR2   \li W972GG6KB   \li 2*256MB
	\endtable

	\section1 SD/MMC Configuration

	The following SD/MMC configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Bus Width           \li Voltage Switch Support
	\row    \li 0        \li SDMMC0     \li 1       \li 1-bit, 4-bit, 8-bit \li yes
	\row    \li 1        \li SDMMC1     \li 1       \li 1-bit, 4-bit        \li no
	\endtable

	\section2 Pin List for SD/MMC Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA0A  \li Clock
	\row    \li PA1A  \li Command
	\row    \li PA2A  \li Data 0 (bus width: 1-bit, 4-bit, 8-bit)
	\row    \li PA3A  \li Data 1 (bus width: 4-bit, 8-bit)
	\row    \li PA4A  \li Data 2 (bus width: 4-bit, 8-bit)
	\row    \li PA5A  \li Data 3 (bus width: 4-bit, 8-bit)
	\row    \li PA6A  \li Data 4 (bus width: 8-bit)
	\row    \li PA7A  \li Data 5 (bus width: 8-bit)
	\row    \li PA8A  \li Data 6 (bus width: 8-bit)
	\row    \li PA9A  \li Data 7 (bus width: 8-bit)
	\row    \li PA11A \li VDD Selection
	\endtable

	\section2 Pin List for SD/MMC Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA22E  \li Clock
	\row    \li PA28E  \li Command
	\row    \li PA18E  \li Data 0 (bus width: 1-bit, 4-bit)
	\row    \li PA19E  \li Data 1 (bus width: 4-bit)
	\row    \li PA20E  \li Data 2 (bus width: 4-bit)
	\row    \li PA21E  \li Data 3 (bus width: 4-bit)
	\endtable

	\section1 SPI Serial Flash Configuration

	The following SPI Serial Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Chip Selects
	\row    \li 0        \li SPI0       \li 1, 2    \li 0, 1, 2, 3
	\row    \li 1        \li SPI1       \li 1, 2    \li 0, 1, 2, 3
	\row    \li 1        \li SPI1       \li 3       \li 0, 1, 2
	\row    \li 2        \li FLEXCOM0   \li 1       \li 0, 1
	\row    \li 3        \li FLEXCOM1   \li 1       \li 0, 1
	\row    \li 4        \li FLEXCOM2   \li 1, 2    \li 0, 1
	\row    \li 5        \li FLEXCOM3   \li 1, 2, 3 \li 0, 1
	\row    \li 6        \li FLEXCOM4   \li 1, 2, 3 \li 0, 1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA16A \li MISO
	\row    \li PA15A \li MOSI
	\row    \li PA14A \li SPCK
	\row    \li PA17A \li NPCS0
	\row    \li PA18A \li NPCS1
	\row    \li PA19A \li NPCS2
	\row    \li PA20A \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 0 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PA31C \li MISO
	\row    \li PB0C  \li MOSI
	\row    \li PB1C  \li SPCK
	\row    \li PA30C \li NPCS0
	\row    \li PA29C \li NPCS1
	\row    \li PA27C \li NPCS2
	\row    \li PA28C \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin  \li Use
	\row    \li PC3D \li MISO
	\row    \li PC2D \li MOSI
	\row    \li PC1D \li SPCK
	\row    \li PC4D \li NPCS0
	\row    \li PC5D \li NPCS1
	\row    \li PC6D \li NPCS2
	\row    \li PC7D \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PA24D \li MISO
	\row    \li PA23D \li MOSI
	\row    \li PA22D \li SPCK
	\row    \li PA25D \li NPCS0
	\row    \li PA26D \li NPCS1
	\row    \li PA27D \li NPCS2
	\row    \li PA28D \li NPCS3
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 1 (I/O Set 3)

	\table
	\header \li Pin   \li Use
	\row    \li PD27A \li MISO
	\row    \li PD26A \li MOSI
	\row    \li PD25A \li SPCK
	\row    \li PD28A \li NPCS0
	\row    \li PD29A \li NPCS1
	\row    \li PD30A \li NPCS2
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 2 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC28C \li MOSI
	\row    \li PC29C \li MISO
	\row    \li PC30C \li SPCK
	\row    \li PB31C \li NPCS0
	\row    \li PC0C  \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 3 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA24A \li MOSI
	\row    \li PA23A \li MISO
	\row    \li PA22A \li SPCK
	\row    \li PA25A \li NPCS0
	\row    \li PA26A \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 4 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA6E  \li MOSI
	\row    \li PA7E  \li MISO
	\row    \li PA8E  \li SPCK
	\row    \li PA9E  \li NPCS0
	\row    \li PA10E \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 4 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PD26C \li MOSI
	\row    \li PD27C \li MISO
	\row    \li PD28C \li SPCK
	\row    \li PD29C \li NPCS0
	\row    \li PD30C \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA15E \li MOSI
	\row    \li PA13E \li MISO
	\row    \li PA14E \li SPCK
	\row    \li PA16E \li NPCS0
	\row    \li PA17E \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PC20E \li MOSI
	\row    \li PC19E \li MISO
	\row    \li PC18E \li SPCK
	\row    \li PC21E \li NPCS0
	\row    \li PC22E \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 5 (I/O Set 3)

	\table
	\header \li Pin   \li Use
	\row    \li PB23E \li MOSI
	\row    \li PB22E \li MISO
	\row    \li PB21E \li SPCK
	\row    \li PB24E \li NPCS0
	\row    \li PB25E \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 6 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PC28B \li MOSI
	\row    \li PC29B \li MISO
	\row    \li PC30B \li SPCK
	\row    \li PC31B \li NPCS0
	\row    \li PD0B  \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 6 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PD12B \li MOSI
	\row    \li PD13B \li MISO
	\row    \li PD14B \li SPCK
	\row    \li PD15B \li NPCS0
	\row    \li PD16B \li NPCS1
	\endtable

	\section2 Pin List for SPI Serial Flash Instance 6 (I/O Set 3)

	\table
	\header \li Pin   \li Use
	\row    \li PD21C \li MOSI
	\row    \li PD22C \li MISO
	\row    \li PD23C \li SPCK
	\row    \li PD24C \li NPCS0
	\row    \li PD25C \li NPCS1
	\endtable

	\section1 NAND Flash Configuration

	The following NAND Flash configurations are supported:

	\table
	\header \li I/O Set \li Bus Width
	\row    \li 1, 2    \li 8-bit, 16-bit
	\endtable

	\section2 Pin List for NAND Flash (I/O Set 1)

	\table
	\header \li Pin   \li Use     \li Bus Width
	\row    \li PA30B \li NANDWE  \li 8-bit, 16-bit
	\row    \li PA31B \li NCS3    \li 8-bit, 16-bit
	\row    \li PB0B  \li NANDALE \li 8-bit, 16-bit
	\row    \li PB1B  \li NANDCLE \li 8-bit, 16-bit
	\row    \li PB2B  \li NANDOE  \li 8-bit, 16-bit
	\row    \li PC8B  \li NANDRDY \li 8-bit, 16-bit
	\row    \li PA22B \li D0      \li 8-bit, 16-bit
	\row    \li PA23B \li D1      \li 8-bit, 16-bit
	\row    \li PA24B \li D2      \li 8-bit, 16-bit
	\row    \li PA25B \li D3      \li 8-bit, 16-bit
	\row    \li PA26B \li D4      \li 8-bit, 16-bit
	\row    \li PA27B \li D5      \li 8-bit, 16-bit
	\row    \li PA28B \li D6      \li 8-bit, 16-bit
	\row    \li PA29B \li D7      \li 8-bit, 16-bit
	\row    \li PB3B  \li D8      \li 16-bit
	\row    \li PB4B  \li D9      \li 16-bit
	\row    \li PB5B  \li D10     \li 16-bit
	\row    \li PB6B  \li D11     \li 16-bit
	\row    \li PB7B  \li D12     \li 16-bit
	\row    \li PB8B  \li D13     \li 16-bit
	\row    \li PB9B  \li D14     \li 16-bit
	\row    \li PB10B \li D15     \li 16-bit
	\endtable

	\section2 Pin List for NAND Flash (I/O Set 2)

	\table
	\header \li Pin   \li Use     \li Bus Width
	\row    \li PA8F  \li NANDWE  \li 8-bit, 16-bit
	\row    \li PA9F  \li NCS3    \li 8-bit, 16-bit
	\row    \li PA10F \li NANDALE \li 8-bit, 16-bit
	\row    \li PA11F \li NANDCLE \li 8-bit, 16-bit
	\row    \li PA12F \li NANDOE  \li 8-bit, 16-bit
	\row    \li PA21F \li NANDRDY \li 8-bit, 16-bit
	\row    \li PA0F  \li D0      \li 8-bit, 16-bit
	\row    \li PA1F  \li D1      \li 8-bit, 16-bit
	\row    \li PA2F  \li D2      \li 8-bit, 16-bit
	\row    \li PA3F  \li D3      \li 8-bit, 16-bit
	\row    \li PA4F  \li D4      \li 8-bit, 16-bit
	\row    \li PA5F  \li D5      \li 8-bit, 16-bit
	\row    \li PA6F  \li D6      \li 8-bit, 16-bit
	\row    \li PA7F  \li D7      \li 8-bit, 16-bit
	\row    \li PA12F \li D8      \li 16-bit
	\row    \li PA13F \li D9      \li 16-bit
	\row    \li PA14F \li D10     \li 16-bit
	\row    \li PA15F \li D11     \li 16-bit
	\row    \li PA16F \li D12     \li 16-bit
	\row    \li PA17F \li D13     \li 16-bit
	\row    \li PA18F \li D14     \li 16-bit
	\row    \li PA18F \li D15     \li 16-bit
	\endtable

	\section1 QSPI Flash Configuration

	The following QSPI Flash configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set
	\row    \li 0        \li QSPI0      \li 1, 2, 3
	\row    \li 1        \li QSPI1      \li 1, 2, 3
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 1)

	\table
	\header \li Pin   \li Use
	\row    \li PA0B  \li SCK
	\row    \li PA1B  \li CS
	\row    \li PA2B  \li IO0
	\row    \li PA3B  \li IO1
	\row    \li PA4B  \li IO2
	\row    \li PA5B  \li IO3
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 2)

	\table
	\header \li Pin   \li Use
	\row    \li PA14C \li SCK
	\row    \li PA15C \li CS
	\row    \li PA16C \li IO0
	\row    \li PA17C \li IO1
	\row    \li PA18C \li IO2
	\row    \li PA19C \li IO3
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 0 (I/O Set 3)

	\table
	\header \li Pin   \li Use
	\row    \li PA22F \li SCK
	\row    \li PA23F \li CS
	\row    \li PA24F \li IO0
	\row    \li PA25F \li IO1
	\row    \li PA26F \li IO2
	\row    \li PA27F \li IO3
	\endtable


	\section2 Pin List for QSPI Serial Flash Instance 1 (I/O Set 1)

	\table
	\header \li Pin   \li Use \li I/O Sets
	\row    \li PA6B  \li SCK \li 1
	\row    \li PA11B \li CS  \li 1
	\row    \li PA7B  \li IO0 \li 1
	\row    \li PA8B  \li IO1 \li 1
	\row    \li PA9B  \li IO2 \li 1
	\row    \li PA10B \li IO3 \li 1
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 1 (I/O Set 2)

	\table
	\header \li Pin   \li Use \li I/O Sets
	\row    \li PB5D  \li SCK \li 2
	\row    \li PB6D  \li CS  \li 2
	\row    \li PB7D  \li IO0 \li 2
	\row    \li PB8D  \li IO1 \li 2
	\row    \li PB9D  \li IO2 \li 2
	\row    \li PB10D \li IO3 \li 2
	\endtable

	\section2 Pin List for QSPI Serial Flash Instance 1 (I/O Set 3)

	\table
	\header \li Pin   \li Use \li I/O Sets
	\row    \li PB14E \li SCK \li 3
	\row    \li PB15E \li CS  \li 3
	\row    \li PB16E \li IO0 \li 3
	\row    \li PB17E \li IO1 \li 3
	\row    \li PB18E \li IO2 \li 3
	\row    \li PB19E \li IO3 \li 3
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

	/*!
		\brief Configuration for QSPI Flash applet

		See \l{SAMBA.Applet::}{QSPIFlashConfig} for a list of configurable properties.
        */
	property alias qspiflash: qspiflash
	QSPIFlashConfig {
		id: qspiflash
	}
}
