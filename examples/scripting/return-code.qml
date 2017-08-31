import QtQuick 2.3
import SAMBA 3.2

/* Sample script to demonstrate custom script return code
 *
 * sam-ba -x return-code.qml
 * -> returns code 42
 *
 * Note that the Script.returnCode variable can be get/set multiple times
 * during the script runtime. The last set value will be used on script exit.
 *
 * If an exception occurs, the sam-ba tool will return -1 regardless of the
 * value of Script.returnCode.
 */
Item {
	Component.onCompleted: {
		Script.returnCode = 42
	}
}
