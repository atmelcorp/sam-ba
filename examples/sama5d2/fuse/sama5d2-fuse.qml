import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D2 3.2
import "sama5d2-fuse.js" as Fuse

SerialConnection {
	//port: "ttyACM0"
	//port: "COM85"
	//baudRate: 57600

	device: SAMA5D2 {
	}

	onConnectionOpened: {
		// Enable SFC clock in PMC
		Fuse.enableSFC(this)

		// Read and display the 24 fuse data registers
		for (var i = 0; i < 24; i++)
			print("FUSE_DR" + i + " = " + Utils.hex(Fuse.readFuse(this, i), 8))

		// Write fuse data register 5
		//Fuse.writeFuse(this, 5, 0x12345678)

		// Disable SFC clock in PMC
		Fuse.disableSFC(this)
	}
}
