import QtQuick 2.3
import SAMBA 3.1

/*! \internal */
Applet {
	name: "nandflash"
	description: "NAND Flash"
	codeUrl: Qt.resolvedUrl("applets/applet-nandflash-sama5d2.bin")
	codeAddr: 0x220000
	mailboxAddr: 0x220004
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"erasePages"; code:0x31; timeout:1000 },
		AppletCommand { name:"readPages"; code:0x32 },
		AppletCommand { name:"writePages"; code:0x33 }
	]

	/*! \internal */
	function buildInitArgs(connection, device) {
		if (typeof device.config.nandIoset === "undefined")
			throw new Error("Incomplete configuration, missing value for nandIoset")

		if (typeof device.config.nandBusWidth === "undefined")
			throw new Error("Incomplete configuration, missing value for nandBusWidth")

		if (typeof device.config.nandHeader === "undefined")
			throw new Error("Incomplete configuration, missing value for nandHeader")

		var args = defaultInitArgs(connection, device)
		var config = [ device.config.nandIoset,
		               device.config.nandBusWidth,
		               device.config.nandHeader ]
		Array.prototype.push.apply(args, config)
		return args
	}

	/*! \internal */
	function prependNandHeader(nandHeader, data) {
		// prepare nand header
		var header = Utils.createByteArray(52 * 4)
		for (var i = 0; i < 52; i++)
			header.writeu32(i * 4, nandHeader)
		// prepend header to data
		data.prepend(header)
		print("Prepended NAND header prefix (" +
			  Utils.hex(nandHeader, 8) + ")")
	}

	/*! \internal */
	function prepareBootFile(connection, device, data) {
		patch6thVector(data)
		prependNandHeader(device.config.nandHeader, data)
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineParse(device, args)	{
		switch (args.length)
		{
		case 3:
			if (args[2].length > 0) {
				device.config.nandHeader = Number(args[2]);
				if (isNaN(device.config.nandHeader))
					return "Invalid NAND header (not a number)."
			}
			// fall-through
		case 2:
			if (args[1].length > 0) {
				device.config.nandBusWidth = Number(args[1]);
				if (isNaN(device.config.nandBusWidth))
					return "Invalid NAND bus width (not a number)."
			}
			// fall-through
		case 1:
			if (args[0].length > 0) {
				device.config.nandIoset = Number(args[0]);
				if (isNaN(device.config.nandIoset))
					return "Invalid NAND ioset (not a number)."
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
		return ["Syntax: nandflash:[<ioset>]:[8|16]:[<header>]",
				"Examples: nandflash -> NAND flash applet using default board settings",
				"          nandflash:2:8:0xc0098da5 -> NAND flash applet using fully custom settings (IOSET2, 8-bit bus, header is 0xc0098da5)",
				"          nandflash:::0xc0098da5 -> NAND flash applet using default board settings but set header to 0xc0098da5",
				"For information on NAND header values, please refer to SAMA5D2 datasheet section \"15.4.6 Detailed Memory Boot Procedures\"."]
	}
}
