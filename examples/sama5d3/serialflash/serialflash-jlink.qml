import SAMBA 3.1
import SAMBA.Connection.JLink 3.1
import SAMBA.Device.SAMA5D3 3.1

AppletLoader {
	connection: JLinkConnection {
		//port: "99999999"
	}

	device: SAMA5D3Xplained {
		// to use a custom config, replace SAMA5D3Xplained by SAMA5D3 and
		// uncomment the following lines, or see documentation for
		// custom board creation.
		//config {
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
		appletInitialize("lowlevel")

		// initialize serial flash applet
		appletInitialize("serialflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x00000, "application.bin", true)
	}
}
