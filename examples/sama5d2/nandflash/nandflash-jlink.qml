import SAMBA 3.0
import SAMBA.Connection.JLink 3.0
import SAMBA.Device.SAMA5D2 3.0

AppletLoader {
	connection: JLinkConnection {
		//port: "99999999"
	}

	device: SAMA5D2 {
		config: SAMA5D2Config {
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

		// Use GPBR_0 as boot configuration word
		BootCfg.writeBSCR(connection, BootCfg.BSCR_GPBR_VALID | BootCfg.BSCR_GPBR_0)

		// Enable external boot only on SPI0 IOSET1
		BootCfg.writeGPBR(connection, 0, BootCfg.BCW_EXT_MEM_BOOT_ENABLE |
						  BootCfg.BCW_CONSOLE1_IOSET1 |
						  BootCfg.BCW_JTAG_IOSET1 |
						  BootCfg.BCW_SDMMC1_DISABLE |
						  BootCfg.BCW_SDMMC0_DISABLE |
						  BootCfg.BCW_NFC_IOSET_2 |
						  BootCfg.BCW_SPI1_DISABLE |
						  BootCfg.BCW_SPI0_DISABLE |
						  BootCfg.BCW_QSPI1_DISABLE |
						  BootCfg.BCW_QSPI0_DISABLE)
	}
}
