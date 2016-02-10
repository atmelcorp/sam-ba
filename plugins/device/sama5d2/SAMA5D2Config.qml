import QtQuick 2.3

/*!
	\qmltype SAMA5D2Config
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains configuration values for a SAMA5D2 device.

	The default values are for the SAMA5D2 Xplained Ultra board.

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
	/*! SPI peripheral instance (default: 0) */
	property int spiInstance: 0

	/*! SPI I/O set (default: 1) */
	property int spiIoset: 1

	/*! SPI Chip Select (default: 0) */
	property int spiChipSelect: 0

	/*! SPI frequency, in MHz (default: 66) */
	property double spiFreq: 66

	/*! QuadSPI peripheral instance (default: 0) */
	property int qspiInstance: 0

	/*! QuadSPI I/O set (default: 3) */
	property int qspiIoset: 3

	/*! QuadSPI frequency, in MHz (default: 66) */
	property double qspiFreq: 66

	/*! NAND I/O set (default: -1) */
	property int nandIoset: -1

	/*! NAND Bus Width (in bits, default: -1) */
	property int nandBusWidth: -1

	/*! NAND Header (default -1) */
	property double nandHeader: -1
}

