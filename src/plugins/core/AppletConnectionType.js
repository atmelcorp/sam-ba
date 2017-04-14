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

.pragma library

/*! \qmlproperty int AppletConnectionType::USB
    \brief Value passed at applet initialization when connecting via USB. */
var USB = 0

/*! \qmlproperty int AppletConnectionType::SERIAL
    \brief Value passed at applet initialization when connecting via SERIAL. */
var SERIAL = 1

/*! \qmlproperty int AppletConnectionType::JTAG
    \brief Value passed at applet initialization when connecting via JTAG. */
var JTAG = 2
