import QtQuick 2.3

/* Default config (SAMA5D2-XULT) */
Item {
	/* SPI SerialFlash on SPI0, ioSet1, CS0 at 66Mhz */
	property int spiInstance: 0
	property int spiIoset: 1
	property int spiChipSelect: 0
	property double spiFreq: 66

	/* QSPI Flash on QSPI0, ioSet3 at 66Mhz */
	property int qspiInstance: 0
	property int qspiIoset: 3
	property double qspiFreq: 66
}

