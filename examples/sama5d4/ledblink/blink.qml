import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import "led.js" as Led

SerialConnection {
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
