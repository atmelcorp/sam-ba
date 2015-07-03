TEMPLATE = subdirs

DISTFILES += TODO README.md LICENSE.txt

SUBDIRS = \
	sambacore \
	devices \
	examples \
	sambacmd \
	sambaconnectionserial

unix:contains(QT_ARCH, x86_64)|win32:{
	SUBDIRS += sambaconnectionjlink
}
else:{
	message("J-Link pluging disabled: unsupported build architecture")
}

sambacmd.depends = sambacore
sambaconnectionserial.depends = sambacore
sambaconnectionjlink.depends = sambacore
