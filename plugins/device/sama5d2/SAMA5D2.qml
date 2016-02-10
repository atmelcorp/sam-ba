import SAMBA 3.0

/*!
	\qmltype SAMA5D2
	\inqmlmodule SAMBA.Device.SAMA5D2
	\brief Contains chip-specific information about SAMA5D2 device.

	This QML type contains configuration, applets and tools for supporting
	the SAMA5D2 device.

	\section1 Applets

	SAM-BA uses small programs called "Applets" to initialize the device or
	flash external memories. Please see SAMBA::Applet for more information on the
	applet mechanism.

	\section2 Low-Level Applet

	This applet is in charge of configuring the device clocks.

	It is only needed when using JTAG for communication with the device.
	When communication using USB or Serial via the SAM-BA Monitor, the clocks are
	already configured by the ROM-code.

	The only supported command is "init".

	\section2 SerialFlash Applet

	This applet is used to flash AT25 serial flash memories. It supports
	all SPI peripherals present on the SAMA5D2 device (see SAMA5D2Config for
	configuration information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section2 QuadSPI Flash Applet

	This applet is used to flash QuadSPI memories. It supports both QSPI
	controllers present on the SAMA5D2 (see SAMA5D2Config for configuration
	information).

	Supported commands are "init", "read", "write" and "blockErase".

	\section1 Configuration

	When creating an instance of the SAMA5D2 type, some configuration can
	be supplied. This is optional, if no specific configuration is provided,
	settings adapted to the SAMA5D2 Xplained Ultra board will be used.

	The configuration parameters are then used during applet initialization
	where relevant.

	For example, the following QML snipplet configures a device using SPI1
	on I/O set 2 and Chip Select 3 at 33Mhz:

	\qml
	SAMA5D2 {
		config: SAMA5D2Config {
			spiInstance: 1
			spiIoset: 2
			spiChipSelect: 3
			spiFreq: 33
		}
	}
	\endqml

	\section1 Boot Stragegy Configuration

	A specific helper type is provided to configure the Boot Strategy of
	the SAMA5D2. Please refer to documentation of the BootCfg type.

*/
Device {
	name: "SAMA5D2"

	/*! The device configuration used by applets (peripherals, I/O sets, etc.) */
	property SAMA5D2Config config: SAMA5D2Config { }

	applets: [
		Applet {
			name: "lowlevel"
			description: "Low-Level"
			codeUrl: Qt.resolvedUrl("applets/applet-lowlevel-sama5d2.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			commands: {
				"initialize": 0
			}

			function buildInitArgs(connection, device) {
				var args = defaultInitArgs(connection, device)
				Array.prototype.push.apply(args, [0, 0, 0])
				return args
			}
		},
		Applet {
			name: "serialflash"
			description: "AT25/AT26 Serial Flash"
			codeUrl: Qt.resolvedUrl("applets/applet-serialflash-sama5d2.bin")
			codeAddr: 0x220000
			mailboxAddr: 0x220004
			commands: {
				"initialize": 0,
				"erasePages": 0x31,
				"readPages":  0x32,
				"writePages": 0x33
			}

			function buildInitArgs(connection, device) {
				var args = defaultInitArgs(connection, device)
				var config = [device.config.spiInstance,
				              device.config.spiIoset,
				              device.config.spiChipSelect,
				              Math.floor(device.config.spiFreq * 1000000)]
				Array.prototype.push.apply(args, config)
				return args
			}
		},
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

			function buildInitArgs(connection, device) {
				var args = defaultInitArgs(connection, device)
				var config = [device.config.qspiInstance,
				              device.config.qspiIoset,
				              Math.floor(device.config.qspiFreq * 1000000)]
				Array.prototype.push.apply(args, config)
				return args
			}
		}
	]

	/*!
		\brief Initialize the SAMA5D2 device using the given \a connection.

		This method calls checkDeviceID and then reconfigures the
		L2-Cache as SRAM for use by the applets.
	*/
	function initialize(connection) {
		checkDeviceID(connection)

		// Reconfigure L2-Cache as SRAM
		var SFR_L2CC_HRAMC = 0xf8030058
		connection.writeu32(SFR_L2CC_HRAMC, 0)
	}

	/*!
		\brief Checks that the device is a SAMA5D2.

		Reads CHIPID_CIDR register using the given \a connection and display
		a warning if its value does not match the expected value for SAMA5D2.
	*/
	function checkDeviceID(connection) {
		// read CHIPID_CIDR register
		var cidr = connection.readu32(0xfc069000)
		if (cidr !== 0x8a5c08c0)
			print("No known SAMA5D2 chip detected!")
	}
}
