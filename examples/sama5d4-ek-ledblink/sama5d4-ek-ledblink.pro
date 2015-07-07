TEMPLATE = aux

example.path = /examples/sama5d4-ek-ledblink

example.files = \
    blink.qml \
    led.js

INSTALLS += example

win32: {
        example.files += blink.bat
}
else:unix: {
        example.files += blink.sh

	# make launch scripts executable
	scriptexec.path = /
	scriptexec.commands = chmod +x \$(INSTALL_ROOT)/$$example.path/*.sh
	scriptexec.depends = install_example
	INSTALLS += scriptexec
}
