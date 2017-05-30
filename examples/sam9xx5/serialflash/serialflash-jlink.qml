import SAMBA 3.2
import SAMBA.Connection.JLink 3.2
import SAMBA.Device.SAM9xx5 3.2

JLinkConnection {
	//port: "99999999"

	device: SAM9xx5EK {
		// to use a custom config, replace SAM9xx5EK by SAM9xx5 and
		// uncomment the following lines, or see documentation for
		// custom board creation.
		//config {
		//	extram {
		//		preset: 1
		//	}
		//	serialflash {
		//		instance: 0
		//		ioset: 1
		//		chipSelect: 0
		//		freq: 66
		//	}
		//}
	}

	onConnectionOpened: {
		// initialize Low-Level applet
		initializeApplet("lowlevel")

		// initialize External RAM applet
		initializeApplet("extram")

		// initialize serial flash applet
		initializeApplet("serialflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "application.bin", true)
	}
}
