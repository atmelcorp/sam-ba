TEMPLATE = aux

example.path = /examples/samv7-flash

example.files = \
	README.md \
	write-flash-usb.qml \

win32: {
	example.files += write-flash-usb.bat
}
else:unix: {
	example.files += write-flash-usb.sh
}

INSTALLS += example
