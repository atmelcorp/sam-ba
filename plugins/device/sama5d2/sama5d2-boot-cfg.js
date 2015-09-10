/*!
	\qmltype BootCfg
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains utility methods to get/set the SAMA5D2 Boot Configuration.

	This helper type contains several methods and constants to ease the
	configuration of the boot sequence on the SAMA5D2 device.

	The boot configuration word value can be computed using a combination
	of the \tt BCW_* constants. For example:

	\code
	var bcw = BootCfg.BCW_EXT_MEM_BOOT_ENABLE
		| BootCfg.BCW_CONSOLE1_IOSET1
		| BootCfg.BCW_JTAG_IOSET1
		| BootCfg.BCW_SDMMC1_DISABLE
		| BootCfg.BCW_SDMMC0_DISABLE
		| BootCfg.BCW_NFC_DISABLE
		| BootCfg.BCW_SPI1_DISABLE
		| BootCfg.BCW_SPI0_IOSET1
		| BootCfg.BCW_QSPI1_DISABLE
		| BootCfg.BCW_QSPI0_DISABLE
	\endcode

	This boot configuration word will boot only on SPI0 I/O set 1, with
	console on UART1 I/O set 1 and JTAG on I/O set 1.

	The configuration can be written either in backuped registers
	(BCSR/GPBR) which are maintened while the backup power is present, or
	in OTP fuses.

	For example, to write the boot config word in GPBR0:
	\code
	BootCfg.writeBSCR(connection, BootCfg.BSCR_GPBR_VALID | BootCfg.BSCR_GPBR_0)
	BootCfg.writeGPBR(connection, 0, bcw)
	\endcode

	Or to write the boot config word in OTP fuses:
	\code
	BootCfg.enableSFC(connection)
	BootCfg.writeFuse(connection, bcw)
	BootCfg.disableSFC(connection)
	\endcode

	Please see section "Standard Boot Strategies" of the SAMA5D2 Datasheet
	for more information on the boot sequence configuration.
*/

.pragma library

/* Peripheral IDs */

var ID_SFC = 50

/* SFC */

var REG_SFC_KR   = 0xf804c000
var SFC_KR_KEY   = 0xfb
var REG_SFC_DR16 = 0xf804c060
var REG_SFC_SR   = 0xf804c01c
var SFC_SR_PGMC  = 1 << 0

/* PMC */

var REG_PMC_PCR = 0xf001410c
var PMC_PCR_EN  = 1 << 28
var PMC_PCR_CMD = 1 << 12

/* BCSR */

var REG_BSC_CR      = 0xf8048054
var BSCR_WPKEY      = 0x6683 << 16
/*! \qmlproperty int BootCfg::BSCR_GPBR_VALID
    \brief BSCR bits for indicating that boot config word should come from GPBR. */
var BSCR_GPBR_VALID = 1 << 2
var BSCR_MASK       = 3
/*! \qmlproperty int BootCfg::BSCR_GPBR_0
    \brief BSCR bits for indicating that boot config word is GPBR0. */
var BSCR_GPBR_0     = 0
/*! \qmlproperty int BootCfg::BSCR_GPBR_1
    \brief BSCR bits for indicating that boot config word is GPBR1. */
var BSCR_GPBR_1     = 1
/*! \qmlproperty int BootCfg::BSCR_GPBR_2
    \brief BSCR bits for indicating that boot config word is GPBR2. */
var BSCR_GPBR_2     = 2
/*! \qmlproperty int BootCfg::BSCR_GPBR_3
    \brief BSCR bits for indicating that boot config word is GPBR3. */
var BSCR_GPBR_3     = 3

/* GPBR */

var REG_GPBR = [ 0xf8045400, 0xf8045404, 0xf8045408, 0xf804540c ]

/* Boot Config Word bits & masks */

var BCW_QSPI0_MASK          = 3 << 0
/*! \qmlproperty int BootCfg::BCW_QSPI0_IOSET1
    \brief Boot Config Word bits for booting on QSPI0 I/O set 1. */
var BCW_QSPI0_IOSET1        = 0 << 0
/*! \qmlproperty int BootCfg::BCW_QSPI0_IOSET2
    \brief Boot Config Word bits for booting on QSPI0 I/O set 2. */
var BCW_QSPI0_IOSET2        = 1 << 0
/*! \qmlproperty int BootCfg::BCW_QSPI0_IOSET3
    \brief Boot Config Word bits for booting on QSPI0 I/O set 3. */
var BCW_QSPI0_IOSET3        = 2 << 0
/*! \qmlproperty int BootCfg::BCW_QSPI0_DISABLE
    \brief Boot Config Word bits for disabling boot on QSPI0. */
var BCW_QSPI0_DISABLE       = 3 << 0

var BCW_QSPI1_MASK          = 3 << 2
/*! \qmlproperty int BootCfg::BCW_QSPI1_IOSET1
    \brief Boot Config Word bits for booting on QSPI1 I/O set 1. */
var BCW_QSPI1_IOSET1        = 0 << 2
/*! \qmlproperty int BootCfg::BCW_QSPI1_IOSET2
    \brief Boot Config Word bits for booting on QSPI1 I/O set 2. */
var BCW_QSPI1_IOSET2        = 1 << 2
/*! \qmlproperty int BootCfg::BCW_QSPI1_IOSET3
    \brief Boot Config Word bits for booting on QSPI1 I/O set 3. */
var BCW_QSPI1_IOSET3        = 2 << 2
/*! \qmlproperty int BootCfg::BCW_QSPI1_DISABLE
    \brief Boot Config Word bits for disabling boot on QSPI1. */
var BCW_QSPI1_DISABLE       = 3 << 2

var BCW_SPI0_MASK           = 3 << 4
/*! \qmlproperty int BootCfg::BCW_SPI0_IOSET1
    \brief Boot Config Word bits for booting on SPI0 I/O set 1. */
var BCW_SPI0_IOSET1         = 0 << 4
/*! \qmlproperty int BootCfg::BCW_SPI0_IOSET2
    \brief Boot Config Word bits for booting on SPI0 I/O set 2. */
var BCW_SPI0_IOSET2         = 1 << 4
/*! \qmlproperty int BootCfg::BCW_SPI0_DISABLE
    \brief Boot Config Word bits for disabling boot on SPI0. */
var BCW_SPI0_DISABLE        = 3 << 4

var BCW_SPI1_MASK           = 3 << 6
/*! \qmlproperty int BootCfg::BCW_SPI1_IOSET1
    \brief Boot Config Word bits for booting on SPI1 I/O set 1. */
var BCW_SPI1_IOSET1         = 0 << 6
/*! \qmlproperty int BootCfg::BCW_SPI1_IOSET2
    \brief Boot Config Word bits for booting on SPI1 I/O set 2. */
var BCW_SPI1_IOSET2         = 1 << 6
/*! \qmlproperty int BootCfg::BCW_SPI1_IOSET3
    \brief Boot Config Word bits for booting on SPI1 I/O set 3. */
var BCW_SPI1_IOSET3         = 2 << 6
/*! \qmlproperty int BootCfg::BCW_SPI1_DISABLE
    \brief Boot Config Word bits for disabling boot on SPI1. */
var BCW_SPI1_DISABLE        = 3 << 6

var BCW_NFC_MASK            = 3 << 8
/*! \qmlproperty int BootCfg::BCW_NFC_IOSET1
    \brief Boot Config Word bits for booting on NFC I/O set 1. */
var BCW_NFC_IOSET1          = 0 << 8
/*! \qmlproperty int BootCfg::BCW_NFC_IOSET2
    \brief Boot Config Word bits for booting on NFC I/O set 2. */
var BCW_NFC_IOSET2          = 1 << 8
/*! \qmlproperty int BootCfg::BCW_NFC_DISABLE
    \brief Boot Config Word bits for disabling boot on NFC. */
var BCW_NFC_DISABLE         = 3 << 8

/*! \qmlproperty int BootCfg::BCW_SDMMC0_DISABLE
    \brief Boot Config Word bits for disabling boot on SDMMC0. */
var BCW_SDMMC0_DISABLE      = 1 << 10

/*! \qmlproperty int BootCfg::BCW_SDMMC1_DISABLE
    \brief Boot Config Word bits for disabling boot on SDMMC1. */
var BCW_SDMMC1_DISABLE      = 1 << 11

var BCW_CONSOLE_MASK        = 15 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE1_IOSET1
    \brief Boot Config Word bits for setting console on UART1 I/O set 1. */
var BCW_CONSOLE1_IOSET1     = 0 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE0_IOSET1
    \brief Boot Config Word bits for setting console on UART0 I/O set 1. */
var BCW_CONSOLE0_IOSET1     = 1 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE1_IOSET2
    \brief Boot Config Word bits for setting console on UART1 I/O set 2. */
var BCW_CONSOLE1_IOSET2     = 2 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE2_IOSET1
    \brief Boot Config Word bits for setting console on UART2 I/O set 1. */
var BCW_CONSOLE2_IOSET1     = 3 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE2_IOSET2
    \brief Boot Config Word bits for setting console on UART2 I/O set 2. */
var BCW_CONSOLE2_IOSET2     = 4 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE2_IOSET3
    \brief Boot Config Word bits for setting console on UART2 I/O set 3. */
var BCW_CONSOLE2_IOSET3     = 5 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE3_IOSET1
    \brief Boot Config Word bits for setting console on UART3 I/O set 1. */
var BCW_CONSOLE3_IOSET1     = 6 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE3_IOSET2
    \brief Boot Config Word bits for setting console on UART3 I/O set 2. */
var BCW_CONSOLE3_IOSET2     = 7 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE3_IOSET3
    \brief Boot Config Word bits for setting console on UART3 I/O set 3. */
var BCW_CONSOLE3_IOSET3     = 8 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE4_IOSET1
    \brief Boot Config Word bits for setting console on UART4 I/O set 1. */
var BCW_CONSOLE4_IOSET1     = 9 << 12
/*! \qmlproperty int BootCfg::BCW_CONSOLE_DISABLE
    \brief Boot Config Word bits for disabling console. */
var BCW_CONSOLE_DISABLE     = 15 << 12

var BCW_JTAG_MASK           = 3 << 16
/*! \qmlproperty int BootCfg::BCW_JTAG_IOSET1
    \brief Boot Config Word bits for setting JTAG on I/O set 1. */
var BCW_JTAG_IOSET1         = 0 << 16
/*! \qmlproperty int BootCfg::BCW_JTAG_IOSET2
    \brief Boot Config Word bits for setting JTAG on I/O set 2. */
var BCW_JTAG_IOSET2         = 1 << 16
/*! \qmlproperty int BootCfg::BCW_JTAG_IOSET3
    \brief Boot Config Word bits for setting JTAG on I/O set 3. */
var BCW_JTAG_IOSET3         = 2 << 16
/*! \qmlproperty int BootCfg::BCW_JTAG_IOSET4
    \brief Boot Config Word bits for setting JTAG on I/O set 4. */
var BCW_JTAG_IOSET4         = 3 << 16

/*! \qmlproperty int BootCfg::BCW_EXT_MEM_BOOT_ENABLE
    \brief Boot Config Word bits for enabling boot on external memories. */
var BCW_EXT_MEM_BOOT_ENABLE = 1 << 18

/*! \qmlproperty int BootCfg::BCW_QSPI_XIP_MODE
    \brief Boot Config Word bits for enabling XIP mode on QSPI Flash. */
var BCW_QSPI_XIP_MODE       = 1 << 21

/*! \qmlproperty int BootCfg::BCW_DISABLE_BSCR
    \brief Boot Config Word bits for disabling read of BSCR register.
 
    Only valid if boot configuration word is written in fuses, not for GPBR.
 */
var BCW_DISABLE_BSCR        = 1 << 22

/*! \qmlproperty int BootCfg::BCW_DISABLE_MONITOR
    \brief Boot Config Word bits for disabling SAM-BA Monitor. */
var BCW_DISABLE_MONITOR     = 1 << 24

/*! \qmlproperty int BootCfg::BCW_SECURE_MODE
    \brief Boot Config Word bits for enabling Secure Mode. */
var BCW_SECURE_MODE         = 1 << 29

/*! \qmlproperty int BootCfg::BCW_SEC_DEBUG_DIS
    \brief Boot Config Word bits for disabling JTAG when the CPU is in Secure Mode.
 
    Only valid if boot configuration word is written in fuses, not for GPBR.
 */
var BCW_SEC_DEBUG_DIS  = 1 << 30

/*! \qmlproperty int BootCfg::BCW_JTAG_DIS
    \brief Boot Config Word bits for disabling JTAG.
 
    Only valid if boot configuration word is written in fuses, not for GPBR.
 */
var BCW_JTAG_DIS       = 1 << 31

/*!
	\qmlmethod int BootCfg::readBSCR(Connection conn)
	Reads BSCR using connection \a conn.
 */
function readBSCR(conn) {
	return conn.readu32(REG_BSC_CR)
}

/*!
	\qmlmethod void BootCfg::writeBSCR(Connection conn, int value)
	Writes BSCR \a value using connection \a conn.
 */
function writeBSCR(conn, value) {
	conn.writeu32(REG_BSC_CR, BSCR_WPKEY | (value & 0xffff))
}

/*!
	\qmlmethod int BootCfg::readGPBR(Connection conn, int idx)
	Reads GPBR at index \a idx using connection \a conn.
*/
function readGPBR(conn, idx) {
	return conn.readu32(REG_GPBR[idx])
}

/*!
	\qmlmethod void BootCfg::writeGPBR(Connection conn, int index, int value)
	Writes \a value to GPBR at index \a idx using connection \a conn.
*/
function writeGPBR(conn, index, value) {
	conn.writeu32(REG_GPBR[index], value)
}

/*!
	\qmlmethod void BootCfg::enableSFC(Connection conn)
	Enables SFC (Secure Fuse Controller) peripheral clock using connection
	\a conn.
*/
function enableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | PMC_PCR_EN | ID_SFC)
}

/*!
	\qmlmethod void BootCfg::disableSFC(Connection conn)
	Disables SFC (Secure Fuse Controller) peripheral clock using connection
	\a conn.
 */
function disableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | ID_SFC)
}

/*!
	\qmlmethod int BootCfg::readFuse(Connection conn)
	\brief Reads Boot Config Fuse (DR16) using connection \a conn.

	Note that the Secure Fuse Controller peripheral clock must have been
	enabled first using enableSFC.
 */
function readFuse(conn) {
	return conn.readu32(REG_SFC_DR16)
}

/*!
	\qmlmethod void BootCfg::writeFuse(Connection conn, int value)
	\brief Writes \a value to Boot Config Fuse (DR16) using connection \a
	conn.

	Note that the Secure Fuse Controller peripheral clock must have been
	enabled first using enableSFC.
*/
function writeFuse(conn, value) {
	// Write the key to SFC_KR register
	conn.writeu32(REG_SFC_KR, SFC_KR_KEY)

	// Write value to data register 16
	conn.writeu32(REG_SFC_DR16, value)

	// Wait for completion by polling SFC_SR register
	while ((conn.readu32(REG_SFC_SR) & SFC_SR_PGMC) != SFC_SR_PGMC) {}
}

/*!
	\qmlmethod void BootCfg::resetConfig(Connection conn)
	Clears BSCR and all GPBRs using connection \a conn.
*/
function resetConfig(conn) {
	writeBSCR(conn, 0)
	writeGPBR(conn, 0, 0)
	writeGPBR(conn, 1, 0)
	writeGPBR(conn, 2, 0)
	writeGPBR(conn, 3, 0)
}

/*!
	\qmlmethod void BootCfg::printConfig(Connection conn)
	Reads BCSR/GPBR/Fuse configuration using connection \a conn and displays
	it in a user-friendly way.
 */
function printConfig(conn) {
	print("BSCR      = " + bscrToText(readBSCR(conn)))
	print("GPBR[0]   = " + configToText(readGPBR(conn, 0)))
	print("GPBR[1]   = " + configToText(readGPBR(conn, 1)))
	print("GPBR[2]   = " + configToText(readGPBR(conn, 2)))
	print("GPBR[3]   = " + configToText(readGPBR(conn, 3)))
	print("Boot Fuse = " + configToText(readFuse(conn)))
}

/*!
	\qmlmethod string BootCfg::bscrToText(int value)
	Converts a boot sequence config register \a value to text for user display.
*/
function bscrToText(value) {
	var text = []

	if (value & BSCR_GPBR_VALID)
		text.push("GPBR_VALID")

	switch (value & BSCR_MASK) {
	case BSCR_GPBR_0:
		text.push("GPBR0")
		break;
	case BSCR_GPBR_1:
		text.push("GPBR1")
		break;
	case BSCR_GPBR_2:
		text.push("GPBR2")
		break;
	case BSCR_GPBR_3:
		text.push("GPBR3")
		break;
	}

	return "0x" + value.toString(16) + " (" + text.join(", ") + ")"
}

/*!
	\qmlmethod string BootCfg::configToText(int value)
	Converts a boot config word \a value to text for user display.
*/
function configToText(value) {
	var text = []

	switch (value & BCW_QSPI0_MASK) {
	case BCW_QSPI0_IOSET1:
		text.push("QSPI0_IOSET1")
		break
	case BCW_QSPI0_IOSET2:
		text.push("QSPI0_IOSET2")
		break
	case BCW_QSPI0_IOSET3:
		text.push("QSPI0_IOSET3")
		break
	}

	switch (value & BCW_QSPI1_MASK) {
	case BCW_QSPI1_IOSET1:
		text.push("QSPI1_IOSET1")
		break
	case BCW_QSPI1_IOSET2:
		text.push("QSPI1_IOSET2")
		break
	case BCW_QSPI1_IOSET3:
		text.push("QSPI1_IOSET3")
		break
	}

	switch (value & BCW_SPI0_MASK) {
	case BCW_SPI0_IOSET1:
		text.push("SPI0_IOSET1")
		break
	case BCW_SPI0_IOSET2:
		text.push("SPI0_IOSET2")
		break
	}

	switch (value & BCW_SPI1_MASK) {
	case BCW_SPI1_IOSET1:
		text.push("SPI1_IOSET1")
		break
	case BCW_SPI1_IOSET2:
		text.push("SPI1_IOSET2")
		break
	case BCW_SPI1_IOSET3:
		text.push("SPI1_IOSET3")
		break
	}

	switch (value & BCW_NFC_MASK) {
	case BCW_NFC_IOSET1:
		text.push("NFC_IOSET1")
		break
	case BCW_NFC_IOSET2:
		text.push("NFC_IOSET2")
		break
	}

	if ((value & BCW_SDMMC0_DISABLE) == 0)
		text.push("SDMMC0")

	if ((value & BCW_SDMMC1_DISABLE) == 0)
		text.push("SDMMC1")

	switch (value & BCW_CONSOLE_MASK) {
	case BCW_CONSOLE1_IOSET1:
		text.push("CONSOLE1_IOSET1")
		break
	case BCW_CONSOLE0_IOSET1:
		text.push("CONSOLE0_IOSET1")
		break
	case BCW_CONSOLE1_IOSET2:
		text.push("CONSOLE1_IOSET2")
		break
	case BCW_CONSOLE2_IOSET1:
		text.push("CONSOLE2_IOSET1")
		break
	case BCW_CONSOLE2_IOSET2:
		text.push("CONSOLE2_IOSET2")
		break
	case BCW_CONSOLE2_IOSET3:
		text.push("CONSOLE2_IOSET3")
		break
	case BCW_CONSOLE3_IOSET1:
		text.push("CONSOLE3_IOSET1")
		break
	case BCW_CONSOLE3_IOSET2:
		text.push("CONSOLE3_IOSET2")
		break
	case BCW_CONSOLE3_IOSET3:
		text.push("CONSOLE3_IOSET3")
		break
	case BCW_CONSOLE4_IOSET1:
		text.push("CONSOLE4_IOSET1")
		break
	}

	switch (value & BCW_JTAG_MASK) {
	case BCW_JTAG_IOSET1:
		text.push("JTAG_IOSET1")
		break
	case BCW_JTAG_IOSET2:
		text.push("JTAG_IOSET2")
		break
	case BCW_JTAG_IOSET3:
		text.push("JTAG_IOSET3")
		break
	case BCW_JTAG_IOSET4:
		text.push("JTAG_IOSET4")
		break
	}

	if (value & BCW_EXT_MEM_BOOT_ENABLE)
		text.push("EXT_MEM_BOOT")

	if (value & BCW_QSPI_XIP_MODE)
		text.push("QSPI_XIP_MODE")

	if (value & BCW_DISABLE_BSCR)
		text.push("DISABLE_BSCR")

	if (value & BCW_DISABLE_MONITOR)
		text.push("DISABLE_MONITOR")

	if (value & BCW_SECURE_MODE)
		text.push("SECURE_MODE")

	if (value & BCW_SEC_DEBUG_DIS)
		text.push("SEC_DEBUG_DISABLED")

	if (value & BCW_JTAG_DIS)
		text.push("JTAG_DISABLED")

	return "0x" + value.toString(16) + " (" + text.join(", ") + ")"
}
