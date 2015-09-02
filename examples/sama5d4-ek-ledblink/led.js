.pragma library

// LEDS: PIOE8, PIOE9 (inverted), PIOE28

var PIO_WPMR = 0xfc06d0e4
var PIO_PUDR = 0xfc06d060
var PIO_MDDR = 0xfc06d054
var PIO_SODR = 0xfc06d030
var PIO_CODR = 0xfc06d034
var PIO_OER = 0xfc06d010
var PIO_PER = 0xfc06d000

var LED0 = 1 << 8
var LED1 = 1 << 9
var LED2 = 1 << 28

function setup(conn)
{
	print("Configuring LED PIO")
	conn.writeu32(PIO_WPMR, 0x50494f00)
	var mask = LED0 + LED1 + LED2
	conn.writeu32(PIO_PUDR, mask)
	conn.writeu32(PIO_MDDR, mask)
	conn.writeu32(PIO_SODR, mask)
	conn.writeu32(PIO_OER, mask)
	conn.writeu32(PIO_PER, mask)
}

function set(conn, led, onoff)
{
	print("Setting LED " + led + " to " + (onoff ? "ON" : "OFF"))
	switch (led) {
	case 0:
		conn.writeu32(PIO_SODR, LED1 + LED2)
		conn.writeu32(onoff ? PIO_SODR : PIO_CODR, LED0)
		break
	case 1:
		conn.writeu32(PIO_CODR, LED0)
		conn.writeu32(PIO_SODR, LED2)
		conn.writeu32(onoff ? PIO_CODR : PIO_SODR, LED1)
		break
	case 2:
		conn.writeu32(PIO_SODR, LED0)
		conn.writeu32(PIO_CODR, LED1)
		conn.writeu32(onoff ? PIO_CODR : PIO_SODR, LED2)
		break
	default:
		conn.writeu32(PIO_CODR, LED1)
		conn.writeu32(PIO_SODR, LED0 + LED2)
		break
	}
}
