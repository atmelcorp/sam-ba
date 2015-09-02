import QtQuick 2.3
import SAMBA 1.0

// import helper javascript functions in namespace "BootCfg"
import "sama5d2-boot-config.js" as BootCfg

Item {
	Component.onCompleted: {
		print("Opening SAMBA connection")
		var port = samba.connection('at91').ports[0]
		port.baudRate = 57600
		port.connect()

		// enable SFC
		BootCfg.enableSFC(port)

		// read and display previous BSCR/GPBR/Fuse values
		print("-- previous boot config --")
		BootCfg.printConfig(port)

		// clear and disable GPBRx
		BootCfg.resetConfig(port)

		// write new Boot Configuration Word Fuse
		// TODO: Set the correct value using constants from BootCfg
		// and uncomment the writeFuse function call.
		var bcw = BootCfg.BCW_EXT_MEM_BOOT_ENABLE | BootCfg.BCW_QSPI0_IOSET1 | BootCfg.BCW_JTAG_IOSET1
		//BootCfg.writeFuse(port, bcw)

		// read and display new BSCR/GPBR/Fuse values
		print("-- new boot config --")
		BootCfg.printConfig(port)

		// disable SFC
		BootCfg.disableSFC(port)

		// disconnect and exit
		print("Closing SAMBA connection")
		port.disconnect()
		print("Exiting")
		Qt.quit()
	}
}
