TEMPLATE = aux

example.path = /examples/sama5d2-boot-config

example.files = \
    README.md \
    sama5d2-set-boot-config.qml \
    sama5d2-show-boot-config.qml

INSTALLS += example

win32: {
	example.files += \
		sama5d2-set-boot-config.bat \
		sama5d2-show-boot-config.bat
}
else:unix: {
	example.files += \
		sama5d2-set-boot-config.sh \
		sama5d2-show-boot-config.sh

	# make launch scripts executable
	scriptexec.path = /
	scriptexec.commands = chmod +x \$(INSTALL_ROOT)/$$example.path/*.sh
	scriptexec.depends = install_example
	INSTALLS += scriptexec
}
