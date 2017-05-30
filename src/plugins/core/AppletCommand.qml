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

/*!
	\qmltype AppletCommand
	\inqmlmodule SAMBA
	\brief Defines a single Applet command
*/
Item {
	/*!
		\qmlproperty string AppletCommand::name
		\brief The command name
	*/
	property var name

	/*!
		\qmlproperty string AppletCommand::code
		\brief The command code (a byte)
	*/
	property var code

	/*!
		\qmlproperty int AppletCommand::timeout
		\brief The command timeout (in milliseconds)
	*/
	property var timeout: 10000
}
