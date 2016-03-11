import QtQuick 2.3
import SAMBA 3.0

/*! \internal */
Applet {
	name: "qspiflash"
	description: "QSPI Flash"
	codeUrl: Qt.resolvedUrl("applets/applet-qspiflash-sama5d2.bin")
	codeAddr: 0x220000
	mailboxAddr: 0x220004
	commands: {
		"initialize": 0,
		"erasePages": 0x31,
		"readPages":  0x32,
		"writePages": 0x33
	}

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.qspiInstance === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiInstance")
		if (typeof device.config.qspiIoset === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiIoset")
		if (typeof device.config.qspiFreq === "undefined")
			throw new Error("Incomplete configuration, missing value for qspiFreq")
		var args = defaultInitArgs(connection, device)
		var config = [device.config.qspiInstance,
			      device.config.qspiIoset,
			      Math.floor(device.config.qspiFreq * 1000000)]
		Array.prototype.push.apply(args, config)
		return args
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
		switch (args.length) {
		case 3:
			if (args[2].length > 0) {
				device.config.qspiFreq = Number(args[2]);
				if (isNaN(device.config.qspiFreq))
					return "Invalid QSPI frequency (not a number)."
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				device.config.qspiIoset = Number(args[1]);
				if (isNaN(device.config.qspiIoset))
					return "Invalid QSPI ioset (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				device.config.qspiInstance = Number(args[0]);
				if (isNaN(device.config.qspiInstance))
					return "Invalid QSPI instance (not a number)."
			}
			// fall-through
		case 0:
			return true
		default:
			return "Invalid number of arguments."
		}
	}

	/*! \internal */
	function commandLineHelp() {
		return ["Syntax: qspiflash:[<instance>]:[<ioset>]:[<frequency>]",
				"Examples: qspiflash -> QSPI flash applet using default board settings",
				"          qspiflash:0:3:66 -> QSPI flash applet using fully custom settings (QSPI0, IOSET3, 66Mhz)",
				"          qspiflash:::20 -> QSPI flash applet using default board settings but frequency set to 20Mhz"]
	}
}
