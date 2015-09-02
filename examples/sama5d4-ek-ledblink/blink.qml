import QtQuick 2.0
import SAMBA 1.0
import SAMBA.Connection.Serial 1.0
import "led.js" as Led

Item {
	SerialConnection {
		id: connection

		onConnectionOpened: {
			// Setup GPIO
			Led.setup(this)

			// Blink LEDs a few times
			var led = 0
			for (var i = 0; i < 40; i++) {
				Utils.msleep(250)
				Led.set(this, led, true)
				led++
				if (led >= 3)
					led = 0
			}
		}

		onConnectionFailed: print("Connection failed: " + message)
	}

	Component.onCompleted: connection.open()
	Component.onDestruction: connection.close()
}
