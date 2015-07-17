TEMPLATE = aux

example.path = /examples/sama5d2-qspiflash

example.files = \
    README.md \
    write-qspiflash-jlink.qml \
    write-qspiflash-usb.qml

INSTALLS += example

win32: {
	example.files += \
	    write-qspiflash-jlink.bat \
	    write-qspiflash-usb.bat
}
else:unix: {
	example.files += \
	    write-qspiflash-jlink.sh \
	    write-qspiflash-usb.sh

	# make launch scripts executable
	scriptexec.path = /
	scriptexec.commands = chmod +x \$(INSTALL_ROOT)/$$example.path/*.sh
	scriptexec.depends = install_example
	INSTALLS += scriptexec
}
