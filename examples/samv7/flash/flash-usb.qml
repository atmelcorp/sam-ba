import SAMBA 3.0
import SAMBA.Connection.Serial 3.0
import SAMBA.Device.SAMV7 3.0

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
