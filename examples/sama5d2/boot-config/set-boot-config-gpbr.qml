import SAMBA 3.2
import SAMBA.Connection.Serial 3.2
import SAMBA.Device.SAMA5D2 3.2

SerialConnection {
	//port: "ttyACM0"
	//port: "COM85"
	//baudRate: 57600

	device: SAMA5D2 {
	}

	onConnectionOpened: {
		// initialize boot config applet
		initializeApplet("bootconfig")

		// read and display current BSCR/BUREG/FUSE values
		print("-- previous boot config --")
		printBootConfig();

		// Use BUREG0 as boot configuration word
		applet.writeBootCfg(BootCfg.BSCR, BSCR.fromText("VALID,BUREG0"))

		// write new Boot Configuration Word in GPBR
		// TODO: Set the correct boot config word value
		applet.writeBootCfg(BootCfg.BUREG0,
			BCW.fromText("EXT_MEM_BOOT,QSPI0_IOSET1,JTAG_IOSET1"))

		// read and display new BSCR/GPBR/Fuse values
		print("-- new boot config --")
		printBootConfig();
	}

	// read and display current BSCR/BUREG/FUSE values
	function printBootConfig() {
		var bscr = applet.readBootCfg(BootCfg.BSCR)
		print("BSCR=" + Utils.hex(bscr, 8) + " / " + BSCR.toText(bscr))
		var bureg0 = applet.readBootCfg(BootCfg.BUREG0)
		print("BUREG0=" + Utils.hex(bureg0, 8) + " / " + BCW.toText(bureg0))
		var bureg1 = applet.readBootCfg(BootCfg.BUREG1)
		print("BUREG1=" + Utils.hex(bureg1, 8) + " / " + BCW.toText(bureg1))
		var bureg2 = applet.readBootCfg(BootCfg.BUREG2)
		print("BUREG2=" + Utils.hex(bureg2, 8) + " / " + BCW.toText(bureg2))
		var bureg3 = applet.readBootCfg(BootCfg.BUREG3)
		print("BUREG3=" + Utils.hex(bureg3, 8) + " / " + BCW.toText(bureg3))
		var fuse = applet.readBootCfg(BootCfg.FUSE)
		print("FUSE=" + Utils.hex(fuse, 8) + " / " + BCW.toText(fuse))
	}
}
