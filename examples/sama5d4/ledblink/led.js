.pragma library

// LED on SAMA5D4-Xplained: PE15 (inverted)

var PIOA     = 0xfc06a000
var PIOB     = 0xfc06b000
var PIOC     = 0xfc06c000
var PIOD     = 0xfc068000
var PIOE     = 0xfc06d000

var PIO_PER  = 0x00
var PIO_OER  = 0x10
var PIO_SODR = 0x30
var PIO_CODR = 0x34
var PIO_MDDR = 0x54
var PIO_PUDR = 0x60
var PIO_WPMR = 0xe4

var BIT15 = 1 << 15

function setup(conn)
{
	print("Configuring LED PIO")

	// PE15
	conn.writeu32(PIOE + PIO_WPMR, 0x50494f00)
	conn.writeu32(PIOE + PIO_PUDR, BIT15)
	conn.writeu32(PIOE + PIO_MDDR, BIT15)
	conn.writeu32(PIOE + PIO_SODR, BIT15)
	conn.writeu32(PIOE + PIO_OER, BIT15)
	conn.writeu32(PIOE + PIO_PER, BIT15)
}

function on(conn)
{
	print("Setting LED to ON")
	conn.writeu32(PIOE + PIO_CODR, BIT15)
}

function off(conn)
{
	print("Setting LED to OFF")
	conn.writeu32(PIOE + PIO_SODR, BIT15)
}
