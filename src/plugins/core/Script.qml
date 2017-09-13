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

pragma Singleton
import QtQuick 2.3

/*!
\qmltype Script
\inqmlmodule SAMBA
\brief The Script type is a singleton that contains miscellaneous input and
output data for SAM-BA scripts.
*/
Item {
	/*!
		\qmlproperty int Script::arguments
		\brief Additional command-line arguments filled-in by the
		sam-ba tool to be parsed by the user script.
	*/
	property var arguments: []

	/*!
		\qmlproperty int Script::returnCode
		\brief Value returned to the system by the sam-ba tool once the
		command/script execution is complete.
	*/
	property var returnCode: 0

	/*!
		\qmlproperty int Script::traceLevel
		\brief The trace level that will be used for applets
	*/
	property var traceLevel: 3
}
