import SAMBA 1.0
import SAMBA.Connection.Serial 1.0
import SAMBA.Device.SAMV7 1.0

AppletLoader {
	connection: SerialConnection { }

	device: SAMV7 { }

	onConnectionOpened: {
		// load/init lowlevel applet
		appletInitialize("lowlevel")

		// load/init flash applet
		appletInitialize("flash")

		// flash program
		appletWrite(0, "getting-started-flash.bin")

		// set GPNVM1 (boot from flash)
		appletGpnvmSet(1)
	}
}
