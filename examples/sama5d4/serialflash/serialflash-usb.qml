import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import SAMBA.Device.SAMA5D4 3.1

AppletLoader {
	connection: SerialConnection {
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

	device: SAMA5D4 {
		board: "sama5d4-xplained"
		// to use a custom config, remove the board property and uncomment
		// the following lines:
		//config {
		//	spiInstance: 0
		//	spiIoset: 1
		//	spiChipSelect: 0
		//	spiFreq: 66
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
