/*
 * Copyright (c) 2017, Atmel Corporation.
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

/*! \internal */
BootConfigApplet {

	// parameter indexes must match applet index argument
	configParams: [ "SECURITY", "BOOTMODE", "TCM" ]

	/* -------- Configuration Parameters Handling -------- */

	/*! \internal */
	function configValueFromText(index, text) {
		text = text.toLowerCase()

		switch (index) {
		case 0:
			if (text === "enabled")
				return 1
			break;
		case 1:
			if (text === "monitor")
				return 0;
			if (text === "flash")
				return 1;
			break;
		case 2:
			if (text === "disabled")
				return 0
			if (text === "32kb")
				return 1
			if (text === "64kb")
				return 2
			if (text === "128kb")
				return 3
			break;
		}
	}

	/*! \internal */
	function configValueToText(index, value) {
		switch (index) {
		case 0:
			switch (value) {
			case 0:
				return "disabled"
			case 1:
				return "enabled"
			}
			break;
		case 1:
			switch (value) {
			case 0:
				return "monitor"
			case 1:
				return "flash"
			}
			break;
		case 2:
			switch (value) {
			case 0:
				return "disabled"
			case 1:
				return "32KB"
			case 2:
				return "64KB"
			case 3:
				return "128KB"
			}
			break;
		}
	}

	/* -------- Command Line Handling -------- */

	/*! \internal */
	function commandLineCommandHelp(command) {
		if (command === "readcfg") {
			return ["* readcfg - read boot configuration",
			        "Syntax:",
			        "    readcfg:(security|bootmode|tcm)",
			        "Examples:",
			        "    readcfg:security   read the value of the Security Bit (GPNVM[0])",
			        "    readcfg:bootmode   read the value of the Boot Mode (GPNVM[1])",
			        "    readcfg:tcm        read the value of the TCM Configuration (GPNVM[8:7])"]
		}
		else if (command === "writecfg") {
			return ["* writecfg - write boot configuration",
			        "Syntax:",
			        "    writecfg:(security|bootmode|eraselock):<configuration>",
			        "Examples:",
			        "    writecfg:security:1          enable the security bit",
			        "    writecfg:security:enabled    enable the security bit",
			        "    writecfg:bootmode:0          configure for booting from ROM (SAM-BA Monitor)",
			        "    writecfg:bootmode:monitor    configure for booting from ROM (SAM-BA Monitor)",
			        "    writecfg:bootmode:1          configure for booting from Flash",
			        "    writecfg:bootmode:flash      configure for booting from Flash",
			        "    writecfg:tcm:0               configure for 0 Kbytes DTCM + 0 Kbytes ITCM",
			        "    writecfg:tcm:disabled        configure for 0 Kbytes DTCM + 0 Kbytes ITCM",
			        "    writecfg:tcm:1               configure for 32 Kbytes DTCM + 32 Kbytes ITCM",
			        "    writecfg:tcm:32K             configure for 32 Kbytes DTCM + 32 Kbytes ITCM",
			        "    writecfg:tcm:2               configure for 64 Kbytes DTCM + 64 Kbytes ITCM",
			        "    writecfg:tcm:64K             configure for 64 Kbytes DTCM + 64 Kbytes ITCM",
			        "    writecfg:tcm:3               configure for 64 Kbytes DTCM + 64 Kbytes ITCM",
			        "    writecfg:tcm:128K            configure for 128 Kbytes DTCM + 128 Kbytes ITCM"]
		}
	}
}
