import QtQuick 2.3
import SAMBA 1.0

Item {
	Component.onCompleted: {
		print("-I- Opening SAMBA connection")
		var port = samba.connection('at91').ports[0]
		port.connect()

		var device = samba.device("samv7")
		var status

		// lowlevel
		port.writeApplet(device.applet("lowlevel"))
		status = port.executeApplet(Applet.CmdInit, 0)
		if (status != 0)
		{
			print("-E- LowLevel initialization failed (status " + status + ")")
			return
		}
		print("-I- LowLevel initialization done")

		// flash
		port.writeApplet(device.applet("flash"))
		status = port.executeApplet(Applet.CmdInit, 0)
		if (status != 0)
		{
			print("-E- Internal Flash initialization failed (status " + status + ")")
			return
		}
		print("-I- Internal Flash initialization done")
		print("-I- Memory size is " + port.currentApplet.memorySize + " bytes")

		status = port.executeAppletWrite(0, "getting-started-flash.bin")
		if (!status)
		{
			print("-E- Flash write failed")
			return
		}
		print("-I- Flash write done")

		// Set GPNVM1 to 1
		status = port.executeApplet(Applet.CmdGPNVM, 1, 1)
		if (status != 0)
		{
			print("-E- GPNVM1 configuration failed (status " + status + ")")
			return
		}
		print("-I- GPNVM1 configuration done")

		print("-I- Closing SAMBA connection")
		port.disconnect()
	}
}
