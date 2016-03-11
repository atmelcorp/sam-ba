import QtQuick 2.3
import SAMBA 3.1

/*!
	\qmltype Device
	\inqmlmodule SAMBA
	\brief Defines all required data for a given Device
*/
DeviceBase {
	/*!
		\qmlproperty string Device::name
		\brief The device name
	*/

	/*!
		\qmlproperty string Device::applets
		\brief A list of all supported applets for the device
	*/

	/*!
		\qmlmethod Applet Device::applet(string name)
		Returns the applet with name \a name or \tt undefined if not found.
	*/

	/*!
		\qmlmethod void Device::initialize(Connection connection)
		Initialize the device using \a connection.
	*/
	function initialize(connection) {
		// do nothing
	}
}
