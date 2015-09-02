import QtQuick 2.3

Item {
	property string name
	property list<Applet> applets

	function initialize(connection) {

	}

	function appletByName(name) {
		for (var i = 0; i < applets.length; i++) {
			if (applets[i].name === name)
				return applets[i]
		}
		return undefined
	}
}
