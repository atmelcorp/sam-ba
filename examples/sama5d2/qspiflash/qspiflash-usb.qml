import SAMBA 3.0
import SAMBA.Connection.Serial 3.0
import SAMBA.Device.SAMA5D2 3.0

AppletLoader {
	connection: SerialConnection {
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

	device: SAMA5D2 {
		board: "sama5d2-xplained"
		// to use a custom config, remove the board property and uncomment
		// the following lines:
		//config {
		//	qspiInstance: 0
		//	qspiIoset: 3
		//	qspiFreq: 66
		//}
	}

	onConnectionOpened: {
		// initialize QSPI applet
		appletInitialize("qspiflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x00000, "at91bootstrap.bin", true)
		appletWrite(0x04000, "u-boot-env.bin")
		appletWrite(0x08000, "u-boot.bin")
		appletWrite(0x60000, "at91-sama5d2_xplained.dtb")
		appletWrite(0x6c000, "zImage")

		// Use GPBR_0 as boot configuration word
		BootCfg.writeBSCR(connection, BootCfg.BSCR_GPBR_VALID | BootCfg.BSCR_GPBR_0)

		// Enable external boot only on QSPI0 IOSET3
		BootCfg.writeGPBR(connection, 0, BootCfg.BCW_EXT_MEM_BOOT_ENABLE |
						  BootCfg.BCW_CONSOLE1_IOSET1 |
						  BootCfg.BCW_JTAG_IOSET1 |
						  BootCfg.BCW_SDMMC1_DISABLE |
						  BootCfg.BCW_SDMMC0_DISABLE |
						  BootCfg.BCW_NFC_DISABLE |
						  BootCfg.BCW_SPI1_DISABLE |
						  BootCfg.BCW_SPI0_DISABLE |
						  BootCfg.BCW_QSPI1_DISABLE |
						  BootCfg.BCW_QSPI0_IOSET3)
	}
}
