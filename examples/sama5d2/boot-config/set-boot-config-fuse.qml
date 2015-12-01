import QtQuick 2.3
import SAMBA 3.0
import SAMBA.Connection.Serial 3.0
import SAMBA.Device.SAMA5D2 3.0

Item {
	SerialConnection {
		id: connection

		//port: "ttyACM0"
		//port: "COM85"
		//port: "ttyUSB0"
		baudRate: 57600

		onConnectionOpened: {
			// read and display previous BSCR/GPBR/Fuse values
			print("-- previous boot config --")
			BootCfg.printConfig(this)

			// clear and disable GPBRx
			BootCfg.resetConfig(this)

			// write new Boot Configuration Word in Fuses
			// TODO: Set the correct value using constants from BootCfg
			// and uncomment the writeFuse function call.
			var bcw = BootCfg.BCW_EXT_MEM_BOOT_ENABLE |
			          BootCfg.BCW_QSPI0_IOSET1 |
			          BootCfg.BCW_JTAG_IOSET1
			//BootCfg.writeFuse(this, bcw)

			// read and display new BSCR/GPBR/Fuse values
			print("-- new boot config --")
			BootCfg.printConfig(this)
		}

		onConnectionFailed: print("Connection failed: " + message)
	}

	Component.onCompleted: connection.open()
	Component.onDestruction: connection.close()
}
