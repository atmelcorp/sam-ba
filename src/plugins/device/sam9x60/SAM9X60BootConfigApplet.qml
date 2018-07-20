/*
 * Copyright (c) 2018, Microchip.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

import QtQuick 2.3
import SAMBA 3.2
import SAMBA.Applet 3.2
import SAMBA.Device.SAM9X60 3.2

/*! \internal */
BootConfigApplet {
	commands: [
		AppletCommand { name:"initialize"; code:0 },
		AppletCommand { name:"readBootCfg"; code:0x34 },
		AppletCommand { name:"writeBootCfg"; code:0x35 },
		AppletCommand { name:"invalidateBootCfg"; code:0x38 },
		AppletCommand { name:"lockBootCfg"; code:0x39 },
		AppletCommand { name:"refreshBootCfg"; code:0x40 },
		AppletCommand { name:"resetEmulSRAM"; code:0x41 }
	]

	// parameter indexes must match applet index argument
	configParams: [ "BSCR", "BCP-EMUL", "BCP-OTP", "UHCP-EMUL", "UHCP-OTP" ]

	/*! \internal */
	function readBootCfg(index) {
		var value = callReadBootCfg(index)

		if (index === 0)
			return value

		var packetLen
		switch (index) {
		case 1:
		case 2:
			packetLen = 19 * 4
			break
		case 3:
		case 4:
			packetLen = 2 * 4
			break
		}

		var data = connection.appletBufferRead(packetLen)
		if (typeof data !== "object" || data.byteLength !== packetLen)
			throw new Error("Read Boot Config command failed (Boot Config Packet transfer failed)")

		return new Uint32Array(data)
	}

	/*! \internal */
	function writeBootCfg(index, value) {
		if (index !== 0 && !connection.appletBufferWrite(value.buffer))
			throw new Error("Write Boot Config command file (Boot Config Packet transfer failed)")

		callWriteBootCfg(index, value)
	}

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function configValueFromText(index, text) {
		switch (index) {
		case 0:
			return BSCR.fromText(text)
		case 1:
		case 2:
			return BCP.fromText(text)
		case 3:
		case 4:
			return UHCP.fromText(text)
		}
	}

	/*! \internal */
	function configValueToText(index, value) {
		switch (index) {
		case 0:
			return BSCR.toText(value)
		case 1:
		case 2:
			return BCP.toText(value)
		case 3:
		case 4:
			return UHCP.toText(value)
		}
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommands() {
		return [ "readcfg", "writecfg", "invalidatecfg", "lockcfg", "refreshcfg", "resetemul" ]
	}

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return [" * readcfg - read boot configuration",
				"Syntax:",
				"    readcfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|bscr)",
				"Examples:",
				"    readcfg:bcp-otp   read the boot config packet from OTP matrix",
				"    readcfg:bcp-emul  read the boot config packet from OTP emulation mode",
				"    readcfg:uhcp-otp  read the user hardware config packet from OTP matrix",
				"    readcfg:uhcp-emul read the user hardware config packet from OTP emulation mode",
				"    readcfg:bscr      read the boot sequence register (BSCR)"]
		}
		else if (command === "writecfg") {
			return [" * writecfg - write boot configuration",
				"Syntax:",
				"    writecfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul|bscr):<value>",
				"",
				"    <value> := <bscr_value> | <boot_config_text> | <user_hw_config_text>",
				"",
				"    <bscr_value> := \"EMULATION_DISABLED\" | \"EMULATION_ENABLED\"",
				"",
				"    <boot_config_text> := <global_settings> | [ <global_settings> \",\" ] [ <boot_sequence> ]",
				"",
				"    <global_settings> := <global_setting> | <global_setting> \",\" <global_settings>",
				"",
				"    <global_setting> := \"MONITOR_DISABLED\" | <console_ioset>",
				"",
				"    <console_ioset> := \"DBGU\" | \"FLEXCOM0_USART_IOSET1\" | ... | \"FLEXCOM12_USART_IOSET1\"",
				"",
				"    <boot_sequence> := <boot_entry> | <boot_entry> \",\" <boot_sequence>",
				"",
				"    <boot_entry> := <spi_entry> | <qspi_entry> | <sdmmc_entry> | <nfc_entry>",
				"",
				"    <spi_entry> := <spi0_entry> | <spi1_entry> | <spi2_entry> | <spi3_entry> | <spi4_entry> | <spi5_entry>",
				"",
				"    <spi0_entry> := \"FLEXCOM0_SPI_IOSET1\" | \"FLEXCOM0_SPI_IOSET2\"",
				"",
				"    <spi1_entry> := \"FLEXCOM1_SPI_IOSET1\" | \"FLEXCOM1_SPI_IOSET2\"",
				"",
				"    <spi2_entry> := \"FLEXCOM2_SPI_IOSET1\" | \"FLEXCOM2_SPI_IOSET2\"",
				"",
				"    <spi3_entry> := \"FLEXCOM3_SPI_IOSET1\" | \"FLEXCOM3_SPI_IOSET2\"",
				"",
				"    <spi4_entry> := \"FLEXCOM4_SPI_IOSET1\" | \"FLEXCOM4_SPI_IOSET2\" | \"FLEXCOM4_SPI_IOSET3\" | \"FLEXCOM4_SPI_IOSET4\" | \"FLEXCOM4_SPI_IOSET5\" | \"FLEXCOM4_SPI_IOSET6\"",
				"",
				"    <spi5_entry> := \"FLEXCOM5_SPI_IOSET1\" | \"FLEXCOM5_SPI_IOSET2\" | \"FLEXCOM5_SPI_IOSET3\" | \"FLEXCOM5_SPI_IOSET4\" | \"FLEXCOM5_SPI_IOSET5\"",
				"",
				"    <qspi_entry> := \"QSPI0_IOSET1\" | \"QSPI0_IOSET1_XIP\"",
				"",
				"    <sdmmc_entry> := <sdmmc_controller> [ '_' <card_detect_pin> ]",
				"",
				"    <sdmmc_controller> := \"SDMMC0_IOSET1\", \"SDMMC1_IOSET1\"",
				"",
				"    <card_detect_pin> := \"P\" <pio_instance> <pin_number>",
				"",
				"    <pio_instance> := \"A\" | \"B\" | \"C\" | \"D\"",
				"",
				"    <pin_number> := \"0\" | \"1\" | \"2\" | \"3\" | \"4\" | \"5\" | ... | \"29\" | \"30\" | \"31\"",
				"",
				"    <nfc_entry> := \"NFC_IOSET1\" | \"NFC_IOSET2\"",
				"",
				"    <user_hw_config_text> := \"\" | <user_hw_setting> | <user_hw_setting> \",\" <user_hw_config_text>",
				"",
				"    <user_hw_setting> := \"JTAGDIS\" | \"URDDIS\" | \"UPGDIS\" | \"URFDIS\" |",
				"                         \"UHCINVDIS\" | \"UHCLKDIS\" | \"UHCPGDIS\" |",
				"                         \"BCINVDIS\" | \"BCLKDIS\" | \"BCPGDIS\" |",
				"                         \"SBCINVDIS\" | \"SBCLKDIS\" | \"SBCPGDIS\" |",
				"                         \"CINVDIS\" | \"CLKDIS\" | \"CPGDIS\"",
				"",
				"Examples:",
				"    writecfg:bscr:EMULATION_ENABLED                           enable OTP emulation mode",
				"    writecfg:bscr:EMULATION_DISABLED                          disable OTP emulation mode",
				"    writecfg:bcp-emul:DBGU                                    emtpy boot config (console on DBGU) stored in OTP emulation mode",
				"    writecfg:bcp-otp:FLEXCOM0_USART_IOSET1,SDMMC1_IOSET1_PA10 boot config with console on FLEXCOM0, boot from SDMMC1 (PA10 as card-detect pin) stored in OTP matrix"]
		}
		else if (command === "invalidatecfg") {
			return ["* invalidatecfg - invalidate the boot config packet",
				"Syntax:",
				"    invalidatecfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul)",
				"Examples:",
				"    invalidatecfg:bcp-otp   invalidate the boot config packet in OTP matrix",
				"    invalidatecfg:bcp-emul  invalidate the boot config packet in OTP emulation mode",
				"    invalidatecfg:uhcp-otp  invalidate the user hardware config packet in OTP matrix",
				"    invalidatecfg:uhcp-emul invalidate the user hardware config packet in OTP emulation mode"]
		}
		else if (command === "lockcfg") {
			return ["* lockcfg - lock the boot config packet",
				"Syntax:",
				"    lockcfg:(bcp-otp|bcp-emul|uhcp-otp|uhcp-emul)",
				"Examples:",
				"    lockcfg:bcp-otp   lock the boot config packet in OTP matrix",
				"    lockcfg:bcp-emul  lock the boot config packet in OTP emulation mode",
				"    lockcfg:uhcp-otp  lock the user hardware config packet in OTP matrix",
				"    lockcfg:uhcp-emul lock the user hardware config packet in OTP emulation mode"]
		}
		else if (command === "refreshcfg") {
			return ["* refreshcfg - refresh the OTP matrix or emulation mode",
				"Syntax:",
				"    refreshcfg:(otp|emul)",
				"Examples:",
				"    refreshcfg:otp   disable the OTP emulation mode, if needed, then refresh the OTPC",
				"    refreshcfg:emul  enable the OTP emulation mode, if needed, then refresh the OTPC"]
		}
		else if (command === "resetemul") {
			return ["* resetemul - reset the OTPC SRAM used in emulation mode",
				"Syntax:",
				"    resetemul",
				"Example:",
				"    resetemul  reset the internal SRAM used by the OTPC in emulation mode"]
		}
	}

	/*! \internal */
	function commandLineCommandWriteBootConfig(args) {
		if (args.length !== 2)
			return "Invalid number of arguments (expected 2)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 0)
			return "Unknown configuration parameter"

		// value
		var value = configValueFromText(index, args[1])
		if (typeof value === "undefined")
			return "Invalid value parameter"
		var text = configValueToText(index, value)
		if (typeof text === "string")
			print("Setting " + configParams[index] + " to " + text)
		writeBootCfg(index, value)
	}

	/*! \internal */
	function commandLineCommandInvalidateBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (exepcted 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 1)
			return "Unknown configuration parameter"

		var cmd = command("invalidateBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Invalidate Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Invalidate Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandLockBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (exepcted 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"
		var param = args[0]

		// get index
		var index = configParamIndex(param)
		if (index < 1)
			return "Unknown configuration parameter"

		var cmd = command("lockBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Lock Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Lock Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandRefreshBootConfig(args) {
		if (args.length !== 1)
			return "Invalid number of arguments (expected 1)."

		// param (required)
		if (args[0].length === 0)
			return "Invalid configuration parameter (empty)"

		var index
		if (args[0].toUpperCase() === "OTP")
			index = 0
		else if (args[0].toUpperCase() === "EMUL")
			index = 1
		else
			return "Unknown configuration parameter"

		var cmd = command("refreshBootCfg")
		if (cmd) {
			var status = connection.appletExecute(cmd, [index])
			if (status !== 0)
				throw new Error("Refresh Boot Config command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Refresh Boot Config' command")
		}
	}

	/*! \internal */
	function commandLineCommandResetEmulSRAM(args) {
		if (args.length !== 0)
			return "Invalid number of arguments (expected 0)."

		var cmd = command("resetEmulSRAM")
		if (cmd) {
			var status = connection.appletExecute(cmd, [])
			if (status !== 0)
				throw new Error("Reset Emulation SRAM command failed (status=" +
						status + ")")
		} else {
			throw new Error("Applet does not support 'Reset Emulation SRAM' command")
		}
	}

	/*! \internal */
	function commandLineCommand(command, args) {
		if (command === "readcfg")
			return commandLineCommandReadBootConfig(args)
		else if (command === "writecfg")
			return commandLineCommandWriteBootConfig(args)
		else if (command === "invalidatecfg")
			return commandLineCommandInvalidateBootConfig(args)
		else if (command === "lockcfg")
			return commandLineCommandLockBootConfig(args)
		else if (command === "refreshcfg")
			return commandLineCommandRefreshBootConfig(args)
		else if (command === "resetemul")
			return commandLineCommandResetEmulSRAM(args)
		else
			return "Unknown command."
	}
}
