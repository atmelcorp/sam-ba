TEMPLATE = subdirs

DISTFILES += TODO

docs.path = /
docs.files = README.md LICENSE.txt
unix:contains(QT_ARCH, arm):docs.files += README.armv7.md
INSTALLS += docs

qtconf.path = /
qtconf.files = qt.conf
INSTALLS += qtconf

SUBDIRS = \
	sambacommon \
	plugins \
	examples \
	sambacmd

# copy Qt libs
unix:{
	qtlibs.path = /
	qtlibs.commands = \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5Core.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5Gui.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5Network.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5Qml.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5Quick.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libQt5SerialPort.so.5 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libicudata.so.54 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libicui18n.so.54 \$(INSTALL_ROOT)/lib && \
		$(COPY) $$[QT_INSTALL_LIBS]/libicuuc.so.54 \$(INSTALL_ROOT)/lib && \
		$(COPY_DIR) $$[QT_INSTALL_LIBS]/../qml/QtQuick.2 \$(INSTALL_ROOT)/qml
	INSTALLS += qtlibs
}
else:win32:{
	qtlibs.path = /
	qtlibs.commands = \
		$(COPY) $$[QT_INSTALL_LIBS]\\Qt5Core.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\Qt5Network.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\Qt5Qml.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\Qt5SerialPort.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\icudt53.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\icuin53.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\icuuc53.dll \$(INSTALL_ROOT) && \
		$(COPY) $$[QT_INSTALL_LIBS]\\libstdc++-6.dll \$(INSTALL_ROOT) \
		$(COPY) $$[QT_INSTALL_LIBS]\\libgcc_s_dw2-1.dll \$(INSTALL_ROOT) \
		$(COPY_DIR) $$[QT_INSTALL_LIBS]\\..\\qml\\QtQuick.2 \$(INSTALL_ROOT)/qml
	INSTALLS += qtlibs
}

sambacmd.depends = sambacommon
