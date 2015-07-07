TEMPLATE = aux

example.path = /examples/samv7-flash

example.files = \
	README.md \
	write-flash-usb.qml \

INSTALLS += example

win32: {
	example.files += write-flash-usb.bat
}
else:unix: {
	example.files += write-flash-usb.sh

	# make launch scripts executable
	scriptexec.path = /
	scriptexec.commands = chmod +x \$(INSTALL_ROOT)/$$example.path/*.sh
	scriptexec.depends = install_example
	INSTALLS += scriptexec
}
