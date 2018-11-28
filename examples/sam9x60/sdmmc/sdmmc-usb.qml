import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAM9X60 3.2

SerialConnection {
	device: SAM9X60EK {
	}

	onConnectionOpened: {
		// change CPU_CLK/MCK frequencies to 600/200 MHz
		initializeApplet("lowlevel")

		// initialize external DDR2
		initializeApplet("extram")

		// initialize SDMMC applet
		initializeApplet("sdmmc")

		// write files
		applet.write(0x00000, "sdcard.img")
	}
}
