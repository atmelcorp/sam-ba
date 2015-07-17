TEMPLATE = subdirs

DISTFILES += TODO

docs.path = /

docs.files = \
	README.md \
	LICENSE.txt

unix:contains(QT_ARCH, arm):docs.files += README.armv7.md

INSTALLS += docs

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
	message("J-Link plugin disabled: unsupported build architecture ("$$QT_ARCH")")
}

unix:{
	qtlibs.path = /libs
	qtlibs.commands = \
		cp -a $$[QT_INSTALL_LIBS]/libQt5Core.so.5* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libQt5Network.so.5* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libQt5Qml.so.5* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libQt5SerialPort.so.5* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libicudata.so.* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libicui18n.so.* \$(INSTALL_ROOT)/libs && \
		cp -a $$[QT_INSTALL_LIBS]/libicuuc.so.* \$(INSTALL_ROOT)/libs
	INSTALLS += qtlibs
}

sambacmd.depends = sambacore
sambaconnectionserial.depends = sambacore
sambaconnectionjlink.depends = sambacore
