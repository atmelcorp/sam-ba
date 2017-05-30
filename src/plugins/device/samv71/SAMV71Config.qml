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
import SAMBA.Applet 3.2

/*!
	\qmltype SAMV71Config
	\inqmlmodule SAMBA.Device.SAMV71
	\brief Contains configuration values for a SAME70/S70/V70/V71 device.

	By default, no configuration values are set.

	\section1 Serial Console Configuration

	The following serial console configurations are supported:

	\table
	\header \li Instance \li Peripheral \li I/O Set \li TX Pin
	\row    \li 0        \li UART0      \li 1       \li PA10A
	\row    \li 1        \li UART1      \li 1       \li PA4C
	\row    \li 1        \li UART1      \li 2       \li PA6C
	\row    \li 1        \li UART1      \li 3       \li PD26D
	\row    \li 2        \li UART2      \li 1       \li PD26C
	\row    \li 3        \li UART3      \li 1       \li PD30A
	\row    \li 3        \li UART3      \li 2       \li PD31B
	\row    \li 4        \li UART4      \li 1       \li PD3C
	\row    \li 4        \li UART4      \li 2       \li PD19C
	\row    \li 5        \li USART0     \li 1       \li PB1C
	\row    \li 6        \li USART1     \li 1       \li PB4D
	\row    \li 7        \li USART2     \li 1       \li PD16B
	\endtable
*/
Item {
	/*!
		\brief Configuration for applet serial console output

		See \l{SAMBA.Applet::}{SerialConfig} for a list of configurable properties.
        */
	property alias serial: serial
	SerialConfig {
		id: serial
	}
}
