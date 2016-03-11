import QtQuick 2.3
import SAMBA 3.0

AppletLoader {
	device: Tool.device

	connection: Tool.port

	onConnectionOpened: {
		appletInitialize(Tool.applet.name)
		var applet = connection.applet

		for (var i = 0; i < Tool.commands.length; i++) {
			var args = Tool.commands[i]
			var command = args.shift()
			print("Executing command '" + Tool.commands[i].join(":") + "'")
			var errMsg
			if (args.length === 1 && args[0] === "help")
				errMsg = applet.commandLineCommandHelp(command)
			else
				errMsg = applet.commandLineCommand(Tool.port, Tool.device,
				                                   command, args)
			if (Array.isArray(errMsg)) {
				for (var j = 0; j < errMsg.length; j++)
					Tool.error(errMsg[j])
				break;
			}
			else if (typeof errMsg === "string") {
				Tool.error("Error: Command '" + Tool.commands[i].join(":") +
				           "': " + errMsg)
				Tool.returnCode = -1
				break
			}
		}
	}

	onConnectionFailed: {
		Tool.error("Error: " + message)
		Tool.returnCode = -1
	}
}
