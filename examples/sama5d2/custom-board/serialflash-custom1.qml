import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D2 3.2

/*
 * This example demonstrates the inline declaration of a custom board
 * configuration.
 *
 * The configuration in this example matches the SAMA5D2 Xplained Ultra board.
 */
SerialConnection {
	device: SAMA5D2 {
		config {
			// eMMC: SDMMC0, I/O Set 1, User Partition, Automatic bus width, 1.8V/3.3V switch supported
			sdmmc {
				instance: 0
				ioset: 1
				partition: 0
				busWidth: 0
				voltages: 1 + 4 /* 1.8V + 3.3V */
			}

			// SPI0, I/O Set 1, NPCS0, 66MHz
			serialflash {
				instance:0
				ioset: 1
				chipSelect: 0
				freq: 66
			}

			// QSPI0, I/O Set 3, 66MHz
			qspiflash {
				instance: 0
				ioset: 3
				freq: 66
			}
		}
	}

	onConnectionOpened: {
		// initialize serial flash applet
		initializeApplet("serialflash")

		// (...)
	}
}
