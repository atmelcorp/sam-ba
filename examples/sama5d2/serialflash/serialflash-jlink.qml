import SAMBA 3.1
import SAMBA.Connection.JLink 3.1
import SAMBA.Device.SAMA5D2 3.1

AppletLoader {
	connection: JLinkConnection {
		//port: "99999999"
	}

	device: SAMA5D2 {
		board: "sama5d2-xplained"
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
		// initialize serial flash applet
		appletInitialize("serialflash")

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

		// Enable external boot only on SPI0 IOSET1
		appletWriteBootCfg(BootCfg.BUREG0,
			BCW.fromText("EXT_MEM_BOOT,UART1_IOSET1,JTAG_IOSET1," +
			             "SDMMC1_DISABLED,SDMMC0_DISABLED,NFC_DISABLED," +
			             "SPI1_DISABLED,SPI0_IOSET1," +
			             "QSPI1_DISABLED,QSPI0_DISABLED"))
	}
}
