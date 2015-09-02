TEMPLATE = lib
CONFIG += plugin
QT -= gui
QT += core qml

TARGET = $$qtLibraryTarget(samba_conn_jlink)

DESTPATH = /qml/SAMBA/Connection/JLink

SOURCES += sambaconnectionjlink.cpp
HEADERS += sambaconnectionjlink.h

# include/link sambacommon library
INCLUDEPATH += $$PWD/../../../sambacommon
DEPENDPATH += $$PWD/../../../sambacommon
win32:CONFIG(release, debug|release):LIBS += -L$$OUT_PWD/../../../sambacommon/release/ -lsambacommon3
else:win32:CONFIG(debug, debug|release):LIBS += -L$$OUT_PWD/../../../sambacommon/debug/ -lsambacommon3
else:unix:LIBS += -L$$OUT_PWD/../../../sambacommon/ -lsambacommon

unix:contains(QT_ARCH, x86_64):{
    JLINKDIR = /opt/SEGGER/JLinkSDK_Linux_V500b_x86_64
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -ljlinkarm

    jlinklibs.path = /lib
    jlinklibs.commands = cp -a $$JLINKDIR/libjlinkarm.so.* \$(INSTALL_ROOT)/lib
    INSTALLS += jlinklibs

    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../../../lib\''
    QMAKE_RPATH =
}
else:win32:{
    JLINKDIR = "C:/Program Files (x86)/SEGGER/JLink_SDK_V500b"
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -lJLinkARM

    jlinklibs.path = /
    jlinklibs.commands = copy /y $$JLINKDIR/JLinkARM.dll \$(INSTALL_ROOT)
    INSTALLS += jlinklibs
}

qml.files = qmldir \
    JLinkConnection.qml

# install
target.path = $$DESTPATH
qml.path = $$DESTPATH
INSTALLS += target qml

OTHER_FILES += $$qml.files
