import SAMBA 1.0

Device {
	name: "SAMV7"

	applets: [
		Applet {
			kind: AppletKind.lowlevel
			name: "lowlevel"
			description: "Low-Level"
			fileUrl: Qt.resolvedUrl("applets/applet-lowlevelinit-samv7.bin")
			appletAddress: 0x20401000
			mailboxAddress: 0x20401040
			initCommand: 0
		},
		Applet {
			kind: AppletKind.nvm
			name: "flash"
			description: "Internal Flash"
			fileUrl: Qt.resolvedUrl("applets/applet-flash-samv7.bin")
			appletAddress: 0x20401000
			mailboxAddress: 0x20401040
			initCommand: 0
			readCommand: 3
			writeCommand: 2
			fullEraseCommand: 1
		}
	]
}
