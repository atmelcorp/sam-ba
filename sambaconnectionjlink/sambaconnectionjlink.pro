TEMPLATE = lib

QT -= gui
QT += core qml

TARGET = sambaplugin_conn_jlink

CONFIG += plugin

SOURCES += \
    sambaconnectionjlink.cpp \
    sambaconnectionportjlink.cpp \
    sambaconnectionpluginjlink.cpp

HEADERS += \
    sambaconnectionjlink.h \
    sambaconnectionportjlink.h \
    sambaconnectionpluginjlink.h

# include/link sambacommon library
INCLUDEPATH += $$PWD/../sambacommon
DEPENDPATH += $$PWD/../sambacommon
win32:CONFIG(release, debug|release):LIBS += -L$$OUT_PWD/../sambacommon/release/ -lsambacommon3
else:win32:CONFIG(debug, debug|release):LIBS += -L$$OUT_PWD/../sambacommon/debug/ -lsambacommon3
else:unix:LIBS += -L$$OUT_PWD/../sambacommon/ -lsambacommon

unix:contains(QT_ARCH, x86_64):{
    JLINKDIR = /opt/SEGGER/JLinkSDK_Linux_V500b_x86_64
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -ljlinkarm

    jlinklibs.path = /
    jlinklibs.commands = cp -a $$JLINKDIR/libjlinkarm.so.* \$(INSTALL_ROOT)/
    INSTALLS += jlinklibs
}
else:win32:{
    JLINKDIR = "C:/Program Files (x86)/SEGGER/JLink_SDK_V500b"
    INCLUDEPATH += $$JLINKDIR/Inc
    LIBS += -L$$JLINKDIR -lJLinkARM
}

# set RPATH to $ORIGIN on Linux
unix:!mac{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_RPATH =
}

# install
target.path = /
INSTALLS += target
