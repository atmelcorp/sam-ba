.pragma library

// LEDS: PIOE8, PIOE9, PIOE28

var PIO_WPMR = 0xfc06d0e4
var PIO_PUDR = 0xfc06d060
var PIO_MDDR = 0xfc06d054
var PIO_SODR = 0xfc06d030
var PIO_CODR = 0xfc06d034
var PIO_OER = 0xfc06d010
var PIO_PER = 0xfc06d000

function setup(port)
{
    print("Configuring LED PIO")
    port.writeu32(PIO_WPMR, 0x50494f00)
    var mask = (1<<8)+(1<<9)+(1<<28)
    port.writeu32(PIO_PUDR, mask)
    port.writeu32(PIO_MDDR, mask)
    port.writeu32(PIO_SODR, mask)
    port.writeu32(PIO_OER, mask)
    port.writeu32(PIO_PER, mask)
}

function set(port, led, onoff)
{
    print("Setting LED " + led + " to " + (onoff ? "ON" : "OFF"))
    switch (led) {
    case 0:
        port.writeu32(PIO_SODR, (1<<9)+(1<<28))
        port.writeu32(onoff ? PIO_SODR : PIO_CODR, 1<<8)
        break
    case 1:
        port.writeu32(PIO_CODR, 1<<8)
        port.writeu32(PIO_SODR, 1<<28)
        port.writeu32(onoff ? PIO_CODR : PIO_SODR, 1<<9)
        break
    case 2:
        port.writeu32(PIO_SODR, 1<<8)
        port.writeu32(PIO_CODR, 1<<9)
        port.writeu32(onoff ? PIO_CODR : PIO_SODR, 1<<28)
        break
    default:
        port.writeu32(PIO_CODR, 1<<9)
        port.writeu32(PIO_SODR, (1<<8)+(1<<28))
        break
    }
}
