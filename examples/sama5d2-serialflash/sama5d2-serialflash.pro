TEMPLATE = aux

example.path = /examples/sama5d2-serialflash

example.files = \
    README.md \
    write-serialflash-jlink.qml \
    write-serialflash-usb.qml

INSTALLS += example

win32: {
	example.files += \
	    write-serialflash-jlink.bat \
	    write-serialflash-usb.bat
}
else:unix: {
	example.files += \
	    write-serialflash-jlink.sh \
	    write-serialflash-usb.sh

	# make launch scripts executable
	scriptexec.path = /
	scriptexec.commands = chmod +x \$(INSTALL_ROOT)/$$example.path/*.sh
	scriptexec.depends = install_example
	INSTALLS += scriptexec
}
