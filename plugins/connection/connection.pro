TEMPLATE = subdirs

SUBDIRS = serial

unix:contains(QT_ARCH, x86_64)|win32:{
	SUBDIRS += jlink
}
else:{
	message("J-Link plugin disabled: unsupported build architecture ("$$QT_ARCH")")
}
