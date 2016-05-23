import QtQuick 2.3
import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import "led.js" as Led

Item {
	SerialConnection {
		id: connection

		onConnectionOpened: {
			// Setup GPIO
			Led.setup(this)

			// Blink LED a few times
			for (var i = 0; i < 40; i++) {
				Utils.msleep(100)
				if ((i & 1) === 0)
					Led.on(this)
				else
					Led.off(this)
			}
		}

		onConnectionFailed: print("Connection failed: " + message)
	}

	Component.onCompleted: connection.open()
	Component.onDestruction: connection.close()
}
