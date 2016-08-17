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
		//	nandIoset: 1
		//	nandBusWidth: 8
		//	nandHeader: 0xc0082405
		//}
	}

	onConnectionOpened: {
		// initialize Low-Level applet
		appletInitialize("lowlevel")

		// initialize External RAM applet
		appletInitialize("extram")

		// initialize NAND flash applet
		appletInitialize("nandflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x000000, "at91bootstrap-sam9-ek.bin", true)
		appletWrite(0x040000, "u-boot-sam9-ek.bin")
		appletWrite(0x0c0000, "u-boot-env-sam9-ek.bin")
		appletWrite(0x180000, "at91-sam9-ek.dtb")
		appletWrite(0x200000, "zImage-sam9-ek.bin")
		appletWrite(0x800000, "atmel-xplained-demo-image-sam9-ek.ubi")
	}
}
