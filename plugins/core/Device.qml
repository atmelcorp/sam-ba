import QtQuick 2.3
import SAMBA 1.0

/*!
	\qmltype Device
	\inqmlmodule SAMBA
	\brief Defines all required data for a given Device
*/
Item {
	/*! Device Name */
	property string name

	/*! List of device applets */
	property list<Applet> applets

	/*!
		\qmlmethod void Device::initialize(Connection connection)
		Initialize the device using \a connection.
	*/
	function initialize(connection) {
		// do nothing
	}

	/*!
		\qmlmethod Applet Device::appletByName(string name)
		Returns the applet with name \a name or \tt undefined if not found.
	*/
	function appletByName(name) {
		for (var i = 0; i < applets.length; i++) {
			if (applets[i].name === name)
				return applets[i]
		}
		return undefined
	}
}
