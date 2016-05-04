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
import SAMBA 3.1

/*!
	\qmltype AppletLoader
	\inqmlmodule SAMBA
	\brief Generic loader/command execution for SAM-BA Applets.

	The AppletLoader QML type is provided to facilitate the use of
	\l{SAMBA::Applet}{SAM-BA Applets}.

	It combines a \l{SAMBA::}{Connection} and a \l{SAMBA::}{Device} and provides
	several functions to call the most common applet commands:
	\list
	\li Initialize
	\li Read
	\li Write
	\li Verify
	\li Full Erase
	\li Partial Erase
	\li Set/Clear GPNVM
	\endlist

	Here is an example script using the AppletLoader to flash a file on the SPI
	flash of a SAMA5D2:

	\qml
	import SAMBA 3.1
	import SAMBA.Connection.Serial 3.1
	import SAMBA.Device.SAMA5D2 3.1

	AppletLoader {
		connection: SerialConnection { }

		device: SAMA5D2 { }

		onConnectionOpened: {
			appletInitialize("serialflash")
			appletErase(0, 1024 * 1024)
			appletWriteVerify(0, "program.bin", true)
		}
	}
	\endqml

	The AppletLoader is created with a SerialConnection and a SAMA5D2 device using
	their default parameters.

	JavaScript code is connected to the \tt ConnectionOpened signal in order to:
	\list
	\li Load and initialize the "serialflash" applet
	\li Erase 1MB at offset 0
	\li Write the contents of file "program.bin" at offset 0 and read it back to
	verify that it was flashed correctly. The third argument ("true")
	indicates that the file must be processed to be bootable.
	\endlist

	To ease the development of flashing scripts, all functions in AppletLoader
	throw a JavaScript \tt Error on failure.  This will effectively stop
	the script on error without having to handle error checking.
*/
Item {
	/*! Device whose applets will be used. */
	property Device device

	/*! Connection used to communicate with applets. */
	property Connection connection

	/*! Whether the connection should be automatically established on
		component completion. */
	property bool autoconnect: true

	/*! Raised when the connection has been opened */
	signal connectionOpened()

	/*! Raised when the connection fails to open.\br
		Failure reason is contained in \a message signal parameter. */
	signal connectionFailed(string message)

	/*! Raised when the connection was closed. */
	signal connectionClosed()

	/*!
		\qmlmethod void AppletLoader::appletInitialize(string appletName)
		\brief Loads and initializes the \a appletName applet.

		Throws an \a Error if the applet is not found or could not be
		loaded/initialized.
	*/
	function appletInitialize(appletName)
	{
		var newapplet = device.applet(appletName)
		if (!newapplet)
			throw new Error("Applet " + appletName + " not found")

		newapplet.initialize(connection, device)
	}

	/*!
		\qmlmethod void AppletLoader::appletRead(int offset, int size, string fileName)
		\brief Read data from the device into a file.

		Reads \a size bytes at offset \a offset using the applet 'read'
		command and writes the data to a file named \a fileName.

		Throws an \a Error if the applet has no read command or if an
		error occured during reading
	*/
	function appletRead(offset, size, fileName)
	{
		connection.applet.read(connection, device, offset, size, fileName)
	}

	/*!
		\qmlmethod void AppletLoader::appletWrite(int offset, string fileName, bool bootFile)
		\brief Writes data from a file to the device.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no write command or if an
		error occured during writing
	*/
	function appletWrite(offset, fileName, bootFile)
	{
		connection.applet.write(connection, device, offset, fileName, bootFile)
	}

	/*!
		\qmlmethod void AppletLoader::appletVerify(int offset, string fileName, bool bootFile)
		\brief Compares data between a file and the device memory.

		Reads the contents of the file named \a fileName and compares
		it with memory at offset \a offset using the applet 'read'
		command.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no read command, if an
		error occured during reading or if the verification failed.
	*/
	function appletVerify(offset, fileName, bootFile)
	{
		connection.applet.verify(connection, device, offset, fileName, bootFile)
	}

	/*!
		\qmlmethod void AppletLoader::appletWriteVerify(int offset, string fileName, bool bootFile)
		\brief Writes/Compares data from a file to the device memory.

		Reads the contents of the file named \a fileName and writes it
		at offset \a offset using the applet 'write' command. The data
		is then read back using the applet 'read' command and compared
		it with the expected data.

		If \a bootFile is \tt true, the file size will be written at
		offset 20 into the data before writing. This is required when
		the code is to be loaded by the ROM code.

		Throws an \a Error if the applet has no read and write commands
		or if an error occured during reading, writing or verifying.
	*/
	function appletWriteVerify(offset, fileName, bootFile)
	{
		connection.applet.writeVerify(connection, device, offset, fileName, bootFile)
	}

	/*!
		\qmlmethod void AppletLoader::appletErase(int offset, int size)
		\brief Erases a block of memory.

		Erases \a size bytes at offset \a offset using the applet
		'block erase' command.

		Throws an \a Error if the applet has no block erase command or
		if an error occured during erasing
	*/
	function appletErase(offset, size)
	{
		connection.applet.erase(connection, device, offset, size)
	}

	/*!
		\qmlmethod void AppletLoader::appletFullErase()
		\brief Fully Erase the Device

		Completely erase the device using the applet 'full erase'
		command or several applet 'page erase' commands.

		Throws an \a Error if the applet has no Full Erase command or
		if an error occured during erase
	*/
	function appletFullErase()
	{
		connection.applet.eraseAll(connection, device)
	}

	/*!
		\qmlmethod void AppletLoader::appletSetGpnvm(int index)
		\brief Sets GPNVM.

		Sets GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during setting GPNVM
	*/
	function appletSetGpnvm(index)
	{
		connection.applet.setGpnvm(connection, device, index)
	}

	/*!
		\qmlmethod void AppletLoader::appletClearGpnvm(int index)
		\brief Clears GPNVM.

		Clears GPNVM at index \a index using the applet 'GPNVM' command.

		Throws an \a Error if the applet has no GPNVM command or if an
		error occured during clearing GPNVM
	*/
	function appletClearGpnvm(index)
	{
		connection.applet.clearGpnvm(connection, device, index)
	}

	/*!
		\qmlmethod int AppletLoader::appletReadBootCfg(int index)
		\brief Read the boot configuration

		Read and returns the boot configuration at index \a index using the applet
		'Read Boot Config' command.

		Throws an \a Error if the applet has no 'Read Boot Config' command or
		if an error occured during calling the applet command
	*/
	function appletReadBootCfg(index)
	{
		return connection.applet.readBootCfg(connection, device, index)
	}

	/*!
		\qmlmethod void AppletLoader::appletWriteBootCfg(int index, int value)
		\brief Write the boot configuration

		Write the boot configuration \a value at index \a index using the
		applet 'Write Boot Config' command.

		Throws an \a Error if the applet has no 'Write Boot Config' command or
		if an error occured during calling the applet command
	*/
	function appletWriteBootCfg(index, value)
	{
		connection.applet.writeBootCfg(connection, device, index, value)
	}

	/*! \internal */
	function handle_connectionOpened()
	{
		print("Connection opened.")
		device.initialize(connection)
		connectionOpened()
	}

	/*! \internal */
	function handle_connectionFailed(message)
	{
		print("Error: " + message)
		connectionFailed(message)
	}

	/*! \internal */
	function handle_connectionClosed()
	{
		print("Connection closed.")
		connectionClosed()
	}

	Component.onCompleted: {
		if (!!connection) {
			connection.connectionOpened.connect(handle_connectionOpened)
			connection.connectionFailed.connect(handle_connectionFailed)
			connection.connectionClosed.connect(handle_connectionClosed)
			if (autoconnect)
				connection.open()
		}
	}

	Component.onDestruction: {
		if (!!connection) {
			connection.close()
		}
	}
}
