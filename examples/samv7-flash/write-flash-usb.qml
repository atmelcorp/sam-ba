import SAMBA 1.0
import SAMBA.Connection.Serial 1.0
import SAMBA.Device.SAMV7 1.0

AppletLoader {
	connection: SerialConnection { }

	device: SAMV7 { }

	onConnectionOpened: {
		// load/init lowlevel applet
		if (!appletInitialize("lowlevel"))
			return

		// load/init flash applet
		if (!appletInitialize("flash"))
			return

		// flash program
		if (!appletWrite(0, "getting-started-flash.bin"))
			return

		// set GPNVM1 (boot from flash)
		if (!appletGpnvmSet(1))
			return
	}
}
