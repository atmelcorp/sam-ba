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
var BSC_CR_GPBR_0     = 0x0
var BSC_CR_GPBR_1     = 0x1
var BSC_CR_GPBR_2     = 0x2
var BSC_CR_GPBR_3     = 0x3

/* GPBR */

var REG_GPBR = [ 0xf8045400, 0xf8045404, 0xf8045408, 0xf804540c ]

/* Boot Config Word bits */

var BCW_QSPI_0_IOSET_1         = 0 << 0
var BCW_QSPI_0_IOSET_2         = 1 << 0
var BCW_QSPI_0_IOSET_3         = 2 << 0
var BCW_QSPI_0_DISABLE         = 3 << 0
var BCW_QSPI_1_IOSET_1         = 0 << 2
var BCW_QSPI_1_IOSET_2         = 1 << 2
var BCW_QSPI_1_IOSET_3         = 2 << 2
var BCW_QSPI_1_DISABLE         = 3 << 2
var BCW_SPI_0_IOSET1           = 0 << 4
var BCW_SPI_0_IOSET2           = 1 << 4
var BCW_SPI_0_DISABLE          = 3 << 4
var BCW_SPI_1_IOSET1           = 0 << 6
var BCW_SPI_1_IOSET2           = 1 << 6
var BCW_SPI_1_IOSET3           = 2 << 6
var BCW_SPI_1_DISABLE          = 3 << 6
var BCW_NFC_IOSET1             = 0 << 8
var BCW_NFC_IOSET2             = 1 << 8
var BCW_NFC_DISABLE            = 3 << 8
var BCW_SDMMC_0_DISABLE        = 1 << 10
var BCW_SDMMC_1_DISABLE        = 1 << 11
var BCW_UART_CONSOLE_1_IOSET_1 = 0 << 12
var BCW_UART_CONSOLE_0_IOSET_1 = 1 << 12
var BCW_UART_CONSOLE_1_IOSET_2 = 2 << 12
var BCW_UART_CONSOLE_2_IOSET_1 = 3 << 12
var BCW_UART_CONSOLE_2_IOSET_2 = 4 << 12
var BCW_UART_CONSOLE_2_IOSET_3 = 5 << 12
var BCW_UART_CONSOLE_3_IOSET_1 = 6 << 12
var BCW_UART_CONSOLE_3_IOSET_2 = 7 << 12
var BCW_UART_CONSOLE_3_IOSET_3 = 8 << 12
var BCW_UART_CONSOLE_4_IOSET_1 = 9 << 12
var BCW_UART_CONSOLE_DISABLE   = 15 << 12
var BCW_JTAG_IOSET_1           = 0 << 16
var BCW_JTAG_IOSET_2           = 1 << 16
var BCW_JTAG_IOSET_3           = 2 << 16
var BCW_JTAG_IOSET_4           = 3 << 16
var BCW_EXT_MEM_BOOT_ENABLE    = 1 << 18
var BCW_KEYS_IN_FUSE           = 1 << 20
var BCW_QSPI_XIP_MODE          = 1 << 21
var BCW_DISABLE_BSCR           = 1 << 22
var BCW_DISABLE_MONITOR        = 1 << 24
var BCW_SECURE_MODE            = 1 << 29

// These bits are only valid for FUSE, not GPBR
var BCW_FUSE_SEC_DEBUG_DIS     = 1 << 30
var BCW_FUSE_JTAG_DIS          = 1 << 31

/**
 * Read Chip ID
 */
function readChipId(port) {
	return port.readu32(REG_CHIPID)
}

/**
 * Read BSCR
 */
function readBSCR(port) {
	return port.readu32(REG_BSC_CR)
}

/**
 * Write BSCR
 */
function writeBSCR(port, value) {
	port.writeu32(REG_BSC_CR, BSC_CR_WPKEY | (value & 0xffff))
}

/**
 * Read GPBR
 */
function readGPBR(port, index) {
	return port.readu32(REG_GPBR[index])
}

/**
 * Write GPBR
 */
function writeGPBR(port, index, value) {
	port.writeu32(REG_GPBR[index], value)
}

/**
 * Enable SFC clock using PMC
 */
function enableSFC(port) {
	port.writeu32(REG_PMC_PCR, PMC_PCR_CMD | PMC_PCR_EN | ID_SFC)
}

/**
 * Disable SFC clock using PMC
 */
function disableSFC(port) {
	port.writeu32(REG_PMC_PCR, PMC_PCR_CMD | ID_SFC)
}

/**
 * Read Boot Config Fuse (DR16)
 */
function readBootConfigFuse(port, value) {
	return port.readu32(REG_SFC_DR16)
}

/**
 * Write Boot Config Fuse (DR16)
 */
function writeBootConfigFuse(port, value) {
	// Write the key to SFC_KR register
	port.writeu32(REG_SFC_KR, SFC_KR_KEY)

	// Write value to data register 16
	port.writeu32(REG_SFC_DR16, value)

	// Wait for completion by polling SFC_SR register
	while ((port.readu32(REG_SFC_SR) & SFC_SR_PGMC) != SFC_SR_PGMC) {}
}
