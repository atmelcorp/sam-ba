import SAMBA 3.2
import SAMBA.Connection.JLink 3.2
import SAMBA.Device.SAMA5D3 3.2

JLinkConnection {
	//port: "99999999"

	device: SAMA5D3Xplained {
		// to use a custom config, replace SAMA5D3Xplained by SAMA5D3 and
		// uncomment the following lines, or see documentation for
		// custom board creation.
		//config {
		//	nandflash {
		//		ioset: 1
		//		busWidth: 8
		//		header: 0xc0902405
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
		applet.write(0x000000, "at91bootstrap-sama5d3_xplained.bin", true)
		applet.write(0x040000, "u-boot-sama5d3-xplained.bin")
		applet.write(0x0c0000, "u-boot-env-sama5d3-xplained.bin")
		applet.write(0x180000, "at91-sama5d3_xplained.dtb")
		applet.write(0x200000, "zImage-sama5d3-xplained.bin")
		applet.write(0x800000, "atmel-xplained-demo-image-sama5d3-xplained.ubi")
	}
}
