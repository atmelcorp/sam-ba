import SAMBA 3.1
import SAMBA.Connection.JLink 3.1
import SAMBA.Device.SAMA5D3 3.1

AppletLoader {
	connection: JLinkConnection {
		//port: "99999999"
	}

	device: SAMA5D3 {
		board: "sama5d3-xplained"
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
