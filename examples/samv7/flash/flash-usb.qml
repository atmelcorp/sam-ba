import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import SAMBA.Device.SAMV7 3.1

AppletLoader {
	connection: SerialConnection { }

	device: SAMV7 { }

	onConnectionOpened: {
		// load/init lowlevel applet
		appletInitialize("lowlevel")

		// load/init flash applet
		appletInitialize("flash")

		// erase all flash
		appletFullErase()

		// flash program
		appletWrite(0, "getting-started-flash.bin")

		// set GPNVM1 (boot from flash)
		appletSetGpnvm(1)
	}
}
