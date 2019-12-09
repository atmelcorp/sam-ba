TEMPLATE = lib
CONFIG += plugin
QT += core qml quick

TARGET = samba_conn_jlink

DESTPATH = /qml/SAMBA/Connection/JLink

SOURCES += sambaconnectionjlinkhelper.cpp
HEADERS += sambaconnectionjlinkhelper.h

unix:{
    INCLUDEPATH += $$JLINKSDKPATH/Inc $$JLINKSDKPATH/Samples_Inc
    LIBS += -L$$JLINKSDKPATH -ljlinkarm

    jlinklibs.path = /lib
    jlinklibs.commands = $(COPY) $$JLINKSDKPATH/libjlinkarm.so.6 \$(INSTALL_ROOT)/lib

    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../../../lib\''
    QMAKE_RPATH =
}
else:win32:{
    INCLUDEPATH += $$JLINKSDKPATH/Inc $$JLINKSDKPATH/Samples_Inc
    LIBS += -L$$JLINKSDKPATH -lJLinkARM

    jlinklibs.path = /
    jlinklibs.files = $$JLINKSDKPATH/JLinkARM.dll
}

INSTALLS += jlinklibs

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
