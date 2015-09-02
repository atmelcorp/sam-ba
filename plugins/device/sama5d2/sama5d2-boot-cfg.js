.pragma library

/* Peripheral IDs */

var ID_SFC = 50

/* CHIPID */

var REG_CHIPID = 0xfc069000

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

var REG_BSC_CR        = 0xf8048054
var BSC_CR_WPKEY      = 0x6683 << 16
var BSC_CR_GPBR_VALID = 1 << 2
var BSC_CR_MASK       = 3
var BSC_CR_GPBR_0     = 0
var BSC_CR_GPBR_1     = 1
var BSC_CR_GPBR_2     = 2
var BSC_CR_GPBR_3     = 3

/* GPBR */

var REG_GPBR = [ 0xf8045400, 0xf8045404, 0xf8045408, 0xf804540c ]

/* Boot Config Word bits & masks */

var BCW_QSPI0_MASK          = 3 << 0
var BCW_QSPI0_IOSET1        = 0 << 0
var BCW_QSPI0_IOSET2        = 1 << 0
var BCW_QSPI0_IOSET3        = 2 << 0
var BCW_QSPI0_DISABLE       = 3 << 0

var BCW_QSPI1_MASK          = 3 << 2
var BCW_QSPI1_IOSET1        = 0 << 2
var BCW_QSPI1_IOSET2        = 1 << 2
var BCW_QSPI1_IOSET3        = 2 << 2
var BCW_QSPI1_DISABLE       = 3 << 2

var BCW_SPI0_MASK           = 3 << 4
var BCW_SPI0_IOSET1         = 0 << 4
var BCW_SPI0_IOSET2         = 1 << 4
var BCW_SPI0_DISABLE        = 3 << 4

var BCW_SPI1_MASK           = 3 << 6
var BCW_SPI1_IOSET1         = 0 << 6
var BCW_SPI1_IOSET2         = 1 << 6
var BCW_SPI1_IOSET3         = 2 << 6
var BCW_SPI1_DISABLE        = 3 << 6

var BCW_NFC_MASK            = 3 << 8
var BCW_NFC_IOSET1          = 0 << 8
var BCW_NFC_IOSET2          = 1 << 8
var BCW_NFC_DISABLE         = 3 << 8

var BCW_SDMMC0_DISABLE      = 1 << 10

var BCW_SDMMC1_DISABLE      = 1 << 11

var BCW_CONSOLE_MASK        = 15 << 12
var BCW_CONSOLE1_IOSET1     = 0 << 12
var BCW_CONSOLE0_IOSET1     = 1 << 12
var BCW_CONSOLE1_IOSET2     = 2 << 12
var BCW_CONSOLE2_IOSET1     = 3 << 12
var BCW_CONSOLE2_IOSET2     = 4 << 12
var BCW_CONSOLE2_IOSET3     = 5 << 12
var BCW_CONSOLE3_IOSET1     = 6 << 12
var BCW_CONSOLE3_IOSET2     = 7 << 12
var BCW_CONSOLE3_IOSET3     = 8 << 12
var BCW_CONSOLE4_IOSET1     = 9 << 12
var BCW_CONSOLE_DISABLE     = 15 << 12

var BCW_JTAG_MASK           = 3 << 16
var BCW_JTAG_IOSET1         = 0 << 16
var BCW_JTAG_IOSET2         = 1 << 16
var BCW_JTAG_IOSET3         = 2 << 16
var BCW_JTAG_IOSET4         = 3 << 16

var BCW_EXT_MEM_BOOT_ENABLE = 1 << 18

var BCW_KEYS_IN_FUSE        = 1 << 20

var BCW_QSPI_XIP_MODE       = 1 << 21

var BCW_DISABLE_BSCR        = 1 << 22

var BCW_DISABLE_MONITOR     = 1 << 24

var BCW_SECURE_MODE         = 1 << 29

/* These bits are only valid for FUSE, not GPBR */

var BCW_FUSE_SEC_DEBUG_DIS  = 1 << 30

var BCW_FUSE_JTAG_DIS       = 1 << 31

/**
 * Read Chip ID
 */
function readChipId(conn) {
	return conn.readu32(REG_CHIPID)
}

/**
 * Read BSCR
 */
function readBSCR(conn) {
	return conn.readu32(REG_BSC_CR)
}

/**
 * Write BSCR
 */
function writeBSCR(conn, value) {
	conn.writeu32(REG_BSC_CR, BSC_CR_WPKEY | (value & 0xffff))
}

/**
 * Read GPBR
 */
function readGPBR(conn, index) {
	return conn.readu32(REG_GPBR[index])
}

/**
 * Write GPBR
 */
function writeGPBR(conn, index, value) {
	conn.writeu32(REG_GPBR[index], value)
}

/**
 * Enable SFC clock using PMC
 */
function enableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | PMC_PCR_EN | ID_SFC)
}

/**
 * Disable SFC clock using PMC
 */
function disableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | ID_SFC)
}

/**
 * Read Boot Config Fuse (DR16)
 */
function readFuse(conn, value) {
	return conn.readu32(REG_SFC_DR16)
}

/**
 * Write Boot Config Fuse (DR16)
 */
function writeFuse(conn, value) {
	// Write the key to SFC_KR register
	conn.writeu32(REG_SFC_KR, SFC_KR_KEY)

	// Write value to data register 16
	conn.writeu32(REG_SFC_DR16, value)

	// Wait for completion by polling SFC_SR register
	while ((conn.readu32(REG_SFC_SR) & SFC_SR_PGMC) != SFC_SR_PGMC) {}
}

/**
 * Clear BSCR and all GPBRs
 */
function resetConfig(conn) {
	writeBSCR(conn, 0)
	writeGPBR(conn, 0, 0)
	writeGPBR(conn, 1, 0)
	writeGPBR(conn, 2, 0)
	writeGPBR(conn, 3, 0)
}

/**
 * Print current BCSR/GPBR/Fuse configuration
 */
function printConfig(conn) {
	print("BSCR      = " + bscrToText(readBSCR(conn)))
	print("GPBR[0]   = " + configToText(readGPBR(conn, 0)))
	print("GPBR[1]   = " + configToText(readGPBR(conn, 1)))
	print("GPBR[2]   = " + configToText(readGPBR(conn, 2)))
	print("GPBR[3]   = " + configToText(readGPBR(conn, 3)))
	print("Boot Fuse = " + configToText(readFuse(conn)))
}

/**
 * Convert a boot sequence config register value to text for user display
 */
function bscrToText(value) {
	var text = []

	if (value & BSC_CR_GPBR_VALID)
		text.push("GPBR_VALID")

	switch (value & BSC_CR_MASK) {
	case BSC_CR_GPBR_0:
		text.push("GPBR0")
		break;
	case BSC_CR_GPBR_1:
		text.push("GPBR1")
		break;
	case BSC_CR_GPBR_2:
		text.push("GPBR2")
		break;
	case BSC_CR_GPBR_3:
		text.push("GPBR3")
		break;
	}

	return "0x" + value.toString(16) + " (" + text.join(", ") + ")"
}


/**
 * Convert a boot config word to text for user display
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

	if (value & BCW_KEYS_IN_FUSE)
		text.push("KEYS_IN_FUSE")

	if (value & BCW_QSPI_XIP_MODE)
		text.push("QSPI_XIP_MODE")

	if (value & BCW_DISABLE_BSCR)
		text.push("DISABLE_BSCR")

	if (value & BCW_DISABLE_MONITOR)
		text.push("DISABLE_MONITOR")

	if (value & BCW_SECURE_MODE)
		text.push("SECURE_MODE")

	if (value & BCW_FUSE_SEC_DEBUG_DIS)
		text.push("SEC_DEBUG_DISABLED")

	if (value & BCW_FUSE_JTAG_DIS)
		text.push("JTAG_DISABLED")

	return "0x" + value.toString(16) + " (" + text.join(", ") + ")"
}
