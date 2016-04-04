import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import SAMBA.Device.SAMA5D2 3.1

AppletLoader {
	connection: SerialConnection {
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

	device: SAMA5D2 {
		// this configuration is suitable for the sama5d2-xplained:
		config {
			// SDMMC0 (eMMC)
			sdmmcInstance: 0
			// Partition 0 (User Partition)
			sdmmcPartition: 0
		}
	}

	onConnectionOpened: {
		// initialize SD/MMC applet
		appletInitialize("sdmmc")

		// write file
		appletWrite(0, "filesystem_image.raw", false)

		// initialize boot config applet
		appletInitialize("bootconfig")

		// Use BUREG0 as boot configuration word
		appletWriteBootCfg(BootCfg.BSCR, BSCR.fromText("VALID,BUREG0"))

		// Enable external boot only on SDMMC0
		appletWriteBootCfg(BootCfg.BUREG0,
			BCW.fromText("EXT_MEM_BOOT,UART1_IOSET1,JTAG_IOSET1," +
			             "SDMMC0,SDMMC1_DISABLED,NFC_DISABLED," +
			             "SPI1_DISABLED,SPI0_DISABLED," +
			             "QSPI1_DISABLED,QSPI0_DISABLED"))
	}
}
