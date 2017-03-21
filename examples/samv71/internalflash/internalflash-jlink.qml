import SAMBA 3.1
import SAMBA.Connection.JLink 3.1
import SAMBA.Device.SAMV71 3.1

AppletLoader {
	connection: JLinkConnection {
		swd: true
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

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
		appletInitialize("internalflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x00000, "program.bin")

		// initialize boot config applet
		appletInitialize("bootconfig")

		// Enable boot from flash
		appletWriteBootCfg(BootCfg.BOOTMODE, BootCfg.BOOTMODE_FLASH)
	}
}
