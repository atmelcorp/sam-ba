import SAMBA 3.1
import SAMBA.Connection.JLink 3.1
import SAMBA.Device.SAM9xx5 3.1

AppletLoader {
	connection: JLinkConnection {
		//port: "99999999"
	}

	device: SAM9xx5 {
		board: "sam9xx5-ek"
		// to use a custom config, remove the board property and uncomment
		// the following lines:
		//config {
		//	extramPreset: 1
		//	spiInstance: 0
		//	spiIoset: 1
		//	spiChipSelect: 0
		//	spiFreq: 66
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
