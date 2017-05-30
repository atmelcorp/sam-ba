import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D4 3.2

SerialConnection {
	//port: "ttyACM0"
	//port: "COM85"
	//baudRate: 57600

	device: SAMA5D4Xplained {
		// to use a custom config, replace SAMA5D4Xplained by SAMA5D4 and
		// uncomment the following lines, or see documentation for
		// custom board creation.
		//config {
		//	serialflash {
		//		ioset: 1
		//		busWidth: 8
		//		header: 0xc1e04e07
		//	}
		//}
	}

	onConnectionOpened: {
		// initialize Low-Level applet
		initializeApplet("lowlevel")

		// initialize NAND flash applet
		initializeApplet("nandflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x000000, "at91bootstrap-sama5d4_xplained.bin", true)
		applet.write(0x040000, "u-boot-sama5d4-xplained.bin")
		applet.write(0x0c0000, "u-boot-env-sama5d4-xplained.bin")
		applet.write(0x180000, "at91-sama5d4_xplained.dtb")
		applet.write(0x200000, "zImage-sama5d4-xplained.bin")
		applet.write(0x800000, "atmel-xplained-demo-image-sama5d4-xplained.ubi")
	}
}
