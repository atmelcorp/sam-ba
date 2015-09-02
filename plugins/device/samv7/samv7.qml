import SAMBA 1.0

Device {
	tag: "samv7"
	name: "SAMV7"

	applets: [
		Applet {
			id: lowlevel
			enabled: true
			kind: Applet.Lowlevel
			tag: "lowlevel"
			name: "Low-Level"
			fileName: Qt.resolvedUrl("applets/applet-lowlevelinit-samv7.bin")
			appletAddress: 0x20401000
			mailboxAddress: 0x20401040
		},
		Applet {
			enabled: lowlevel.initialized
			kind: Applet.NVM
			tag: "flash"
			name: "Internal Flash"
			fileName: Qt.resolvedUrl("applets/applet-flash-samv7.bin")
			appletAddress: 0x20401000
			mailboxAddress: 0x20401040
		}
	]
}
