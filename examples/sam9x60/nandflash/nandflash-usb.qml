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

		// initialize NAND flash applet
		initializeApplet("nandflash")

		// erase all memory
		applet.erase(0, applet.memorySize)

		// write files
		applet.write(0x00000, "at91bootstrap.bin", true)
		applet.write(0x04000, "u-boot-env.bin")
		applet.write(0x08000, "u-boot.bin")
		applet.write(0x60000, "sam9x60_ek.dtb")
		applet.write(0x6c000, "zImage")
	}
}
