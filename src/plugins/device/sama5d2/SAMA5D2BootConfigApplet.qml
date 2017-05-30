/*
 * Copyright (c) 2015-2016, Atmel Corporation.
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
import SAMBA.Device.SAMA5D2 3.2

/*! \internal */
BootConfigApplet {

	// parameter indexes must match applet index argument
	configParams: [ "BSCR", "BUREG0", "BUREG1", "BUREG2", "BUREG3", "FUSE" ]

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function configValueFromText(index, text) {
		switch (index) {
		case 0:
			return BSCR.fromText(text)
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			return BCW.fromText(text)
		}
	}

	/*! \internal */
	function configValueToText(index, value) {
		switch (index) {
		case 0:
			return BSCR.toText(value)
		case 1:
		case 2:
		case 3:
		case 4:
		case 5:
			return BCW.toText(value)
		}
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return ["* readcfg - read boot configuration",
			        "Syntax:",
			        "    readcfg:(fuse|bureg0|bureg1|bureg2|bureg3|bscr)",
			        "Examples:",
			        "    readcfg:fuse    read boot configuration word in fuses",
			        "    readcfg:bureg0  read boot configuration word in BUREG0",
			        "    readcfg:bscr    read boot sequence register (BSCR)"]
		}
		else if (command === "writecfg") {
			return ["* writecfg - write boot configuration",
			        "Syntax:",
			        "    writecfg:(fuse|bureg0|bureg1|bureg2|bureg3|bscr):<configuration>",
			        "Examples:",
			        "    writecfg:fuse:0x440000                     write boot configuration word 0x440000 in fuses",
			        "    writecfg:bureg0:0x40fcf                    write boot configuration word 0x40fcf in BUREG0",
			        "    writecfg:bureg2:QSPI0_IOSET2,EXT_MEM_BOOT  write boot configuration word 0x40001 in BUREG2",
			        "    writecfg:bscr:4                            write boot sequence register (BUREG0, VALID)",
			        "    writecfg:bscr:bureg0,valid                 write boot sequence register (BUREG0, VALID)",
			        "Configuration value can be either a number or a sequence of tokens separated by commas.",
			        "    BSCR tokens:",
			        "        BUREG0*, BUREG1, BUREG2, BUREG3 -> to select which BUREG to use",
			        "        VALID -> to validate the BSCR and use the selected BUREG",
			        "    BUREG/Fuse tokens:",
			        "        UART1_IOSET1*, UART0_IOSET1, UART1_IOSET2, UART2_IOSET1, UART2_IOSET2, UART2_IOSET3, UART3_IOSET1, UART3_IOSET2, UART3_IOSET3, UART4_IOSET1, UART_DISABLED,",
			        "        JTAG_IOSET1*, JTAG_IOSET2, JTAG_IOSET3, JTAG_IOSET4,",
			        "        QSPI0_IOSET1*, QSPI0_IOSET2, QSPI0_IOSET3, QSPI0_DISABLED,",
			        "        QSPI1_IOSET1*, QSPI1_IOSET2, QSPI1_IOSET, QSPI1_DISABLED,",
			        "        SPI0_IOSET1*, SPI0_IOSET2, SPI0_DISABLED,",
			        "        SPI1_IOSET1*, SPI1_IOSET2, SPI1_IOSET3, SPI1_DISABLED,",
			        "        NFC_IOSET1*, NFC_IOSET2, NFC_DISABLED,",
			        "        SDMMC0*, SDMMC0_DISABLED,",
			        "        SDMMC1*, SDMMC1_DISABLED,",
			        "        EXT_MEM_BOOT,",
			        "        QSPI_XIP_MODE,",
			        "        DISABLE_BSCR,",
			        "        DISABLE_MONITOR,",
			        "        SECURE_MODE,",
			        "    Tokens with a star (*) are selected by default if no token from the same line is provided (field value is 0).",
			        "    Please refer to SAMA5D2 Datasheet section \"15.4 Boot configuration\" for information on boot settings."]
		}
	}
}
