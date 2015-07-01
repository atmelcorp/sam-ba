import SAMBA 1.0
import "led.js" as Led

Script {
	onScriptStarted: {
		print("Opening SAMBA connection")
		var port = samba.connection('at91').ports[0]
		port.connect()

		Led.setup(port)

		var led = 0
		for (var i = 0; i < 40; i++) {
			msleep(250)
			Led.set(port, led, true)
			led++
			if (led >= 3)
				led = 0
		}

		print("Closing SAMBA connection")
		port.disconnect()

		print("Exiting")
		Qt.quit()
	}
}
