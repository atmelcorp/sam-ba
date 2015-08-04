import SAMBA 1.0

// import helper javascript functions in namespace "BC"
import "sama5d2-boot-config.js" as BC

Script {
	onScriptStarted: {
		print("Opening SAMBA connection")
		var port = samba.connection('at91').ports[0]
		port.baudRate = 57600
		port.connect()

		// enable SFC
		BC.enableSFC(port)

		// read and display previous BSCR/GPBR/Fuse values
		print("previous BSCR = 0x" + BC.readBSCR(port).toString(16))
		print("previous GPBR[0] = 0x" + BC.readGPBR(port, 0).toString(16))
		print("previous GPBR[1] = 0x" + BC.readGPBR(port, 1).toString(16))
		print("previous GPBR[2] = 0x" + BC.readGPBR(port, 2).toString(16))
		print("previous GPBR[3] = 0x" + BC.readGPBR(port, 3).toString(16))
		print("previous Boot Config Fuse = 0x" + BC.readBootConfigFuse(port).toString(16))

		// clear and disable GPBRx
		BC.writeBSCR(port, 0)
		BC.writeGPBR(port, 0, 0)
		BC.writeGPBR(port, 1, 0)
		BC.writeGPBR(port, 2, 0)
		BC.writeGPBR(port, 3, 0)

		// write new Boot Configuration Word Fuse
		// TODO: Set the correct value using constants from sama5d2-boot-config.js javascript file
		// and uncomment the writeBootConfigFuse function call.
		var bcw = BC.BCW_EXT_MEM_BOOT_ENABLE | BC.BCW_QSPI_0_IOSET_1 | BC.BCW_JTAG_IOSET_1
		//BC.writeBootConfigFuse(port, bcw)

		// read and display new BSCR/GPBR/Fuse values
		print("new BSCR = 0x" + BC.readBSCR(port).toString(16))
		print("new GPBR[0] = 0x" + BC.readGPBR(port, 0).toString(16))
		print("new GPBR[1] = 0x" + BC.readGPBR(port, 1).toString(16))
		print("new GPBR[2] = 0x" + BC.readGPBR(port, 2).toString(16))
		print("new GPBR[3] = 0x" + BC.readGPBR(port, 3).toString(16))
		print("new Boot Config Fuse = 0x" + BC.readBootConfigFuse(port).toString(16))

		// disable SFC
		BC.disableSFC(port)

		// disconnect and exit
		print("Closing SAMBA connection")
		port.disconnect()
		print("Exiting")
		Qt.quit()
	}
}
