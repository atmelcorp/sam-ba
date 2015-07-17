import SAMBA 1.0

Script {
	onScriptStarted: {
		print("Opening SAMBA connection")
		var port = samba.connection('at91').ports[0]
		port.baudRate = 57600
		port.connect()

		var device = samba.device("sama5d2")
		var status

		// Reconfigure L2-Cache as SRAM
		var SFR_L2CC_HRAMC = 0xf8030058
		port.writeu32(SFR_L2CC_HRAMC, 0)

		// qspiflash
		port.writeApplet(device.applet("qspiflash"))
		status = port.executeApplet(Applet.CmdInit, 0)
		print("qspiflash applet status -> " + status)
		if (status === 0)
		{
			print("memorySize: " + port.readMailbox(0) + " bytes")
			print("appletBufferAddress: 0x" + port.readMailbox(1).toString(16))
			print("appletBufferSize: " + port.readMailbox(2) + " bytes")
		}

		// erase first 6MB
		var offset = 0
		while (offset < 6 * 1024 * 1024) {
			port.executeApplet(Applet.CmdBufferErase, offset)
			offset += 64 * 1024
		}

		port.executeAppletWrite(0x00000, "at91bootstrap.bin")
		port.executeAppletWrite(0x04000, "u-boot-env.bin")
		port.executeAppletWrite(0x08000, "u-boot.bin")
		port.executeAppletWrite(0x60000, "at91-sama5d2_xplained.dtb")
		port.executeAppletWrite(0x6c000, "zImage")

		// Use GPBR_0 as boot configuration word
		var BSC_CR = 0xf8048054
		var BSC_CR_WPKEY = 0x6683 << 16
		var BSC_CR_GPBR_VALID = 1 << 2
		port.writeu32(BSC_CR, BSC_CR_WPKEY | BSC_CR_GPBR_VALID | 0)

		// Enable external boot only on QSPI0 IOSET 3
		var GPBR_0 = 0xf8045400
		var EXT_MEM_BOOT_ENABLE = 1 << 18
		var SDMMC_1_DISABLE = 1 << 11
		var SDMMC_0_DISABLE = 1 << 10
		var NFC_DISABLE = 2 << 8
		var SPI_1_DISABLE = 3 << 6
		var SPI_0_DISABLE = 3 << 4
		var QSPI_1_DISABLE = 3 << 2
		var QSPI_0_IOSET_3 = 2 << 0
		port.writeu32(GPBR_0, EXT_MEM_BOOT_ENABLE | SDMMC_1_DISABLE |
					  SDMMC_0_DISABLE | NFC_DISABLE |
					  SPI_1_DISABLE | SPI_0_DISABLE |
					  QSPI_1_DISABLE | QSPI_0_IOSET_3)

		print("Closing SAMBA connection")
		port.disconnect()

		print("Exiting")
		Qt.quit()
	}
}
