TEMPLATE = lib
CONFIG += plugin
QT += core qml quick

TARGET = samba_conn_jlink

DESTPATH = /qml/SAMBA/Connection/JLink

SOURCES += sambaconnectionjlinkhelper.cpp
HEADERS += sambaconnectionjlinkhelper.h

unix:contains(QT_ARCH, x86_64):{
    JLINKDIR = /opt/SEGGER/JLinkSDK_Linux_V502k_x86_64
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -ljlinkarm

    jlinklibs.path = /lib
    jlinklibs.commands = $(COPY) $$JLINKDIR/libjlinkarm.so.5 \$(INSTALL_ROOT)/lib
    INSTALLS += jlinklibs

    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../../../lib\''
    QMAKE_RPATH =
}
else:unix:contains(QT_ARCH, i386):{
    JLINKDIR = /opt/SEGGER/JLinkSDK_Linux_V502k_i386
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -ljlinkarm

    jlinklibs.path = /lib
    jlinklibs.commands = $(COPY) $$JLINKDIR/libjlinkarm.so.5 \$(INSTALL_ROOT)/lib
    INSTALLS += jlinklibs

    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../../../lib\''
    QMAKE_RPATH =
}
else:win32:{
    JLINKDIR = "C:/Program Files (x86)/SEGGER/JLink_SDK_V502k"
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -lJLinkARM

    jlinklibs.path = /
    jlinklibs.files = $$JLINKDIR/JLinkARM.dll
    INSTALLS += jlinklibs
}

qml.files = \
	qmldir \
	JLinkConnection.qml

metadata.files = \
	connection_jlink.json

# install
target.path = $$DESTPATH
qml.path = $$DESTPATH
metadata.path = /metadata
INSTALLS *= target qml metadata

OTHER_FILES += \
    $$qml.files \
    module_samba_connection_jlink.qdoc
