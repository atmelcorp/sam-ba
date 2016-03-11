import QtQuick 2.3

/*!
	\qmltype SAMA5D2Config
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains configuration values for a SAMA5D2 device.

	By default, no configuration values are set.

	\section1 SPI Configuration

	The following SPI configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li Chip Selects
	\row \li 0 \li SPI0 \li 1, 2 \li 0, 1, 2, 3
	\row \li 1 \li SPI1 \li 1, 2 \li 0, 1, 2, 3
	\row \li 1 \li SPI1 \li 3 \li 0, 1, 2
	\row \li 2 \li FLEXCOM0 \li 1 \li 0, 1
	\row \li 3 \li FLEXCOM1 \li 1 \li 0, 1
	\row \li 4 \li FLEXCOM2 \li 1, 2 \li 0, 1
	\row \li 5 \li FLEXCOM3 \li 1, 2, 3 \li 0, 1
	\row \li 6 \li FLEXCOM4 \li 1, 2, 3 \li 0, 1
	\endtable

	\section1 QuadSPI Configuration

	The following QuadSPI configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set
	\row \li 0 \li QSPI0 \li 1, 2, 3
	\row \li 1 \li QSPI1 \li 1, 2, 3
	\endtable

	\section1 NAND Configuration

	The following NAND configurations are supported:

	\table
	\header \li I/O Set \li Bus Width
	\row \li 1, 2 \li 8-bit, 16-bit
	\endtable
*/
Item {
	/*! SPI peripheral instance */
	property var spiInstance

	/*! SPI I/O set */
	property var spiIoset

	/*! SPI Chip Select */
	property var spiChipSelect

	/*! SPI frequency, in MHz */
	property var spiFreq

	/*! QuadSPI peripheral instance */
	property var qspiInstance

	/*! QuadSPI I/O set */
	property var qspiIoset

	/*! QuadSPI frequency, in MHz */
	property var qspiFreq

	/*! NAND I/O set */
	property var nandIoset

	/*! NAND Bus Width, in bits (8/16) */
	property var nandBusWidth

	/*! NAND Header */
	property var nandHeader
}

