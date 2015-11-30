import SAMBA 3.0

/*!
	\qmltype SAMV7
	\inqmlmodule SAMBA.Device.SAMV7
	\brief Contains chip-specific information about SAMV7 devices.
*/
Device {
	name: "SAMV7"

	applets: [
		Applet {
			name: "lowlevel"
			description: "Low-Level"
			kind: Applet.KindLowLevel
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevelinit-samv7.bin")
			codeAddr: 0x20401000
			mailboxAddr: 0x20401040
			commands: {
				"init": 0
			}
		},
		Applet {
			name: "flash"
			description: "Internal Flash"
			kind: Applet.KindNVM
			codeUrl: Qt.resolvedUrl("applets/applet-flash-samv7.bin")
			codeAddr: 0x20401000
			mailboxAddr: 0x20401040
			commands: {
				"init": 0,
				"read": 3,
				"write": 2,
				"fullErase": 1,
				"gpnvm": 6
			}
		}
	]

	/*!
		\brief Initialize the SAMV7 device using the given \a connection.

		This method calls checkDeviceID.
	*/
	function initialize(connection) {
		checkDeviceID(connection)
	}

	/*!
		\brief Checks that the device is a SAMx7.

		Reads CHIPID_CIDR register using the given \a connection and display
		a warning if its value does not match the expected value for SAMx7.
	*/
	function checkDeviceID(connection) {
		// read ARCH field of CHIPID_CIDR register
		var arch = (connection.readu32(0x400e0940) >> 20) & 0xff
		if (arch < 0x10 || arch > 0x13)
			print("No known SAMx7 chip detected! (arch=" + arch.toString(16) + ")")
	}
}
