TEMPLATE = subdirs

# map Qt version to ICU versions
equals(QT_MAJOR_VERSION, 5) {
	equals(QT_MINOR_VERSION, 9): ICU_VERSION = 56
}
isEmpty(ICU_VERSION) {
	error(Unknown QT version)
}

# for Windows targets, copy AT91 USB driver
win32:SUBDIRS += driver

# copy documents at root of package
rootdocs.path = /
rootdocs.files = README.txt LICENSE.txt CHANGELOG.txt
unix:contains(QT_ARCH, arm):rootdocs.files += README.armv7.txt
INSTALLS += rootdocs

# copy qt.conf
qtconf.path = /
qtconf.files = qt.conf
INSTALLS += qtconf

# copy Qt libs
unix:{
	qtlibs.path = /lib
	qtlibs.files = \
		$$[QT_INSTALL_LIBS]/libQt5Core.so.5 \
		$$[QT_INSTALL_LIBS]/libQt5Gui.so.5 \
		$$[QT_INSTALL_LIBS]/libQt5Network.so.5 \
		$$[QT_INSTALL_LIBS]/libQt5Qml.so.5 \
		$$[QT_INSTALL_LIBS]/libQt5Quick.so.5 \
		$$[QT_INSTALL_LIBS]/libQt5SerialPort.so.5
	INSTALLS += qtlibs

	otherlibs.path = /lib
	otherlibs.files = \
		$$[QT_INSTALL_LIBS]/libicudata.so.$$ICU_VERSION \
		$$[QT_INSTALL_LIBS]/libicui18n.so.$$ICU_VERSION \
		$$[QT_INSTALL_LIBS]/libicuuc.so.$$ICU_VERSION
	INSTALLS += otherlibs

	qmlmodules.path = /qml
	qmlmodules.files = $$[QT_INSTALL_LIBS]/../qml/QtQuick.2
	INSTALLS += qmlmodules
}
else:win32:{
	qtlibs.path = /
	CONFIG(debug, debug|release):{
		qtlibs.files = \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Cored.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Guid.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Networkd.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Qmld.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Quickd.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5SerialPortd.dll
	}
	else:{
		qtlibs.files = \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Core.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Gui.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Network.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Qml.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5Quick.dll \
			$$[QT_INSTALL_LIBS]/../bin/Qt5SerialPort.dll
	}
	INSTALLS += qtlibs

	otherlibs.path = /
	otherlibs.files = \
		$$[QT_INSTALL_LIBS]/../bin/libwinpthread-1.dll \
		$$[QT_INSTALL_LIBS]/../bin/libgcc_s_dw2-1.dll \
		$$[QT_INSTALL_LIBS]/../bin/libstdc++-6.dll \
	otherlibs.CONFIG += no_check_exist
	INSTALLS += otherlibs

	qmlmodules.path = /qml
	qmlmodules.files = $$[QT_INSTALL_LIBS]/../qml/QtQuick.2
	INSTALLS += qmlmodules
}

macx:{
        qtlibs.path = /Frameworks
        qtlibs.files = \
                $$[QT_INSTALL_LIBS]/QtCore.framework \
                $$[QT_INSTALL_LIBS]/QtGui.framework \
                $$[QT_INSTALL_LIBS]/QtNetwork.framework \
                $$[QT_INSTALL_LIBS]/QtQml.framework \
                $$[QT_INSTALL_LIBS]/QtQuick.framework \
                $$[QT_INSTALL_LIBS]/QtSerialPort.framework
        INSTALLS = qtlibs

        otherlibs.path = /Frameworks
        otherlibs.files = \
                /usr/local/Cellar/icu4c/59.1/lib//libicudata.dylib \
                /usr/local/Cellar/icu4c/59.1/lib/libicui18n.dylib \
                /usr/local/Cellar/icu4c/59.1/lib//libicuuc.dylib
        INSTALLS = otherlibs

        qmlmodules.path = /qml
        qmlmodules.files = $$[QT_INSTALL_LIBS]/../qml/QtQuick.2
        INSTALLS = qmlmodules

}
