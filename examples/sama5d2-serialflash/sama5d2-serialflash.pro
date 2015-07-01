TEMPLATE = aux

example.path = /examples/sama5d2-serialflash

example.files = \
    README.md \
    write-serialflash-jlink.qml \
    write-serialflash-usb.qml

win32: {
	example.files += \
	    write-serialflash-jlink.bat \
	    write-serialflash-usb.bat
}
else:unix: {
	example.files += \
	    write-serialflash-jlink.sh \
	    write-serialflash-usb.sh
}

INSTALLS += example
