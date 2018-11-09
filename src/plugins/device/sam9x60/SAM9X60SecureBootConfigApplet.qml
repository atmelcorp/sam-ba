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
SecureBootConfigApplet {
	/*! \internal */
	function secureBootCfgToText(value)
	{
		return SBCP.toText(value)
	}
}
