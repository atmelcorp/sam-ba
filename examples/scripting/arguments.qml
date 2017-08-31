import QtQuick 2.3
import SAMBA 3.2

/* Sample script to demonstrate custom arguments
 *
 * Example command lines and their output:
 *
 * sam-ba -x arguments.qml
 * No arguments!
 *
 * sam-ba -x arguments.qml one two
 * Arg[0] -> one
 * Arg[1] -> two
 *
 * sam-ba one -x arguments.qml two
 * Arg[0] -> one
 * Arg[1] -> two
 *
 * sam-ba -x arguments.qml -- -a -b -c
 * Arg[0] -> -a
 * Arg[1] -> -b
 * Arg[2] -> -c
 */
Item {
	Component.onCompleted: {
		if (Script.arguments.length > 0) {
			for (var i = 0; i < Script.arguments.length; i++)
				print("Arg[" + i + "] -> " + Script.arguments[i])
		} else {
			print("No arguments!");
		}
	}
}
