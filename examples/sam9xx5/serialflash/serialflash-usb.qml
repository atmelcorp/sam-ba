import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import SAMBA.Device.SAM9xx5 3.1

AppletLoader {
	connection: SerialConnection {
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

	device: SAM9xx5 {
		board: "sam9xx5-ek"
		// to use a custom config, remove the board property and uncomment
		// the following lines:
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
		appletInitialize("lowlevel")

		// initialize External RAM applet
		appletInitialize("extram")

		// initialize serial flash applet
		appletInitialize("serialflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x00000, "application.bin", true)
	}
}
