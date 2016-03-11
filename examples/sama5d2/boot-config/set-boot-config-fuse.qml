import QtQuick 2.3
import SAMBA 3.1
import SAMBA.Connection.Serial 3.1
import SAMBA.Device.SAMA5D2 3.1

AppletLoader {
	connection: SerialConnection {
		//port: "ttyACM0"
		//port: "COM85"
		//baudRate: 57600
	}

	device: SAMA5D2 {
	}

	onConnectionOpened: {
		// initialize boot config applet
		appletInitialize("bootconfig")

		// read and display current BSCR/BUREG/FUSE values
		print("-- previous boot config --")
		printBootConfig();

		// Use BUREG0 as boot configuration word
		appletWriteBootCfg(BootCfg.BSCR, BSCR.fromText("VALID,BUREG0"))

		// write new Boot Configuration Word in FUSE
		// TODO: Set the correct boot config word value and uncomment
		// the 'appletWriteBootCfg' function call below
		//appletWriteBootCfg(BootCfg.FUSE,
		//	BCW.fromText("EXT_MEM_BOOT,QSPI0_IOSET1,JTAG_IOSET1"))

		// read and display new BSCR/GPBR/Fuse values
		print("-- new boot config --")
		printBootConfig();
	}

	// read and display current BSCR/BUREG/FUSE values
	function printBootConfig() {
		var bscr = appletReadBootCfg(BootCfg.BSCR)
		print("BSCR=" + Utils.hex(bscr, 8) + " / " + BSCR.toText(bscr))
		var bureg0 = appletReadBootCfg(BootCfg.BUREG0)
		print("BUREG0=" + Utils.hex(bureg0, 8) + " / " + BCW.toText(bureg0))
		var bureg1 = appletReadBootCfg(BootCfg.BUREG1)
		print("BUREG1=" + Utils.hex(bureg1, 8) + " / " + BCW.toText(bureg1))
		var bureg2 = appletReadBootCfg(BootCfg.BUREG2)
		print("BUREG2=" + Utils.hex(bureg2, 8) + " / " + BCW.toText(bureg2))
		var bureg3 = appletReadBootCfg(BootCfg.BUREG3)
		print("BUREG3=" + Utils.hex(bureg3, 8) + " / " + BCW.toText(bureg3))
		var fuse = appletReadBootCfg(BootCfg.FUSE)
		print("FUSE=" + Utils.hex(fuse, 8) + " / " + BCW.toText(fuse))
	}
}
