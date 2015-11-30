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
			// read and display current BSCR/GPBR/Fuse values
			print("-- boot config --")
			BootCfg.printConfig(this)
		}

		onConnectionFailed: print("Connection failed: " + message)
	}

	Component.onCompleted: connection.open()
	Component.onDestruction: connection.close()
}
