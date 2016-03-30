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
		config {
			nandIoset: 2
			nandBusWidth: 8
			nandHeader: 0xc0098da5
		}
	}

	onConnectionOpened: {
		// initialize NAND flash applet
		appletInitialize("nandflash")

		// erase all memory
		appletErase(0, connection.applet.memorySize)

		// write files
		appletWrite(0x00000, "at91bootstrap.bin", true)
		appletWrite(0x04000, "u-boot-env.bin")
		appletWrite(0x08000, "u-boot.bin")
		appletWrite(0x60000, "at91-sama5d2_xplained.dtb")
		appletWrite(0x6c000, "zImage")

		// initialize boot config applet
		appletInitialize("bootconfig")

		// Use BUREG0 as boot configuration word
		appletWriteBootCfg(BootCfg.BSCR, BSCR.fromText("VALID,BUREG0"))

		// Enable external boot only on NFC IOSET2
		appletWriteBootCfg(BootCfg.BUREG0,
			BCW.fromText("EXT_MEM_BOOT,UART1_IOSET1,JTAG_IOSET1," +
			             "SDMMC1_DISABLED,SDMMC0_DISABLED,NFC_IOSET2," +
			             "SPI1_DISABLED,SPI0_DISABLED," +
			             "QSPI1_DISABLED,QSPI0_DISABLED"))
	}
}
