import SAMBA 1.0

Device {
	name: "SAMA5D2"

	property SAMA5D2Config config: SAMA5D2Config {	}

	applets: [
		Applet {
			kind: AppletKind.lowlevel
			name: "lowlevel"
			description: "Low-Level"
			fileUrl: Qt.resolvedUrl("applets/applet-lowlevel-sama5d2.bin")
			appletAddress: 0x220000
			mailboxAddress: 0x220004
			initCommand: 0
		},
		Applet {
			kind: AppletKind.nvm
			name: "serialflash"
			description: "AT25/AT26 Serial Flash"
			fileUrl: Qt.resolvedUrl("applets/applet-serialflash-sama5d2.bin")
			appletAddress: 0x220000
			mailboxAddress: 0x220004
			initCommand: 0
			initArgs: [
				config.spiInstance,
				config.spiIoset,
				config.spiChipSelect,
				Math.floor(config.spiFreq * 1000000)
			]
			readCommand: 3
			writeCommand: 2
			blockEraseCommand: 8
		},
		Applet {
			kind: AppletKind.nvm
			name: "qspiflash"
			description: "QSPI Flash"
			fileUrl: Qt.resolvedUrl("applets/applet-qspiflash-sama5d2.bin")
			appletAddress: 0x220000
			mailboxAddress: 0x220004
			initCommand: 0
			initArgs: [
				config.qspiInstance,
				config.qspiIoset,
				Math.floor(config.qspiFreq * 1000000)
			]
			readCommand: 3
			writeCommand: 2
			blockEraseCommand: 8
		}
	]

	function initialize(connection) {
		// Reconfigure L2-Cache as SRAM
		var SFR_L2CC_HRAMC = 0xf8030058
		connection.writeu32(SFR_L2CC_HRAMC, 0)
	}
}
