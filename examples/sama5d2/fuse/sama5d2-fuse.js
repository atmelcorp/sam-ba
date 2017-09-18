.pragma library

/* Peripheral IDs */

var ID_SFC = 50

/* SFC */

var REG_SFC_KR   = 0xf804c000
var SFC_KR_KEY   = 0xfb
var REG_SFC_DR0  = 0xf804c020
var REG_SFC_SR   = 0xf804c01c
var SFC_SR_PGMC  = 1 << 0

/* PMC */

var REG_PMC_PCR = 0xf001410c
var PMC_PCR_EN  = 1 << 28
var PMC_PCR_CMD = 1 << 12

function enableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | PMC_PCR_EN | ID_SFC)
}

function disableSFC(conn) {
	conn.writeu32(REG_PMC_PCR, PMC_PCR_CMD | ID_SFC)
}

function readFuse(conn, fuse_data_reg) {
	return conn.readu32(REG_SFC_DR0 + fuse_data_reg * 4)
}

function writeFuse(conn, fuse_data_reg, value) {
	// Write the key to SFC_KR register
	conn.writeu32(REG_SFC_KR, SFC_KR_KEY)

	// Write value to data register 16
	conn.writeu32(REG_SFC_DR0 + fuse_data_reg * 4, value)

	// Wait for completion by polling SFC_SR register
	while ((conn.readu32(REG_SFC_SR) & SFC_SR_PGMC) != SFC_SR_PGMC) {}
}
