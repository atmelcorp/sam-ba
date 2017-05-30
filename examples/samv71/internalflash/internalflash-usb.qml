import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMV71 3.2

SerialConnection {
	//port: "ttyACM0"
	//port: "COM85"
	//baudRate: 57600

	device: SAMV71Xplained {
		// to use a custom config, replace SAMV71Xplained by SAMV71 and
		// uncomment the following lines, or see documentation for
		// custom board creation.
		//config {
		//	serial {
		//		instance: 6
		//		ioset: 1
		//	}
		//}
	}

	onConnectionOpened: {
		// initialize internal flash applet
		initializeApplet("internalflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "program.bin")

		// initialize boot config applet
		initializeApplet("bootconfig")

		// Enable boot from flash
		applet.writeBootCfg(BootCfg.BOOTMODE, BootCfg.BOOTMODE_FLASH)
	}
}
