TEMPLATE = lib

QT -= gui
QT += qml

TARGET = sambacommon

VERSION = 3.0.0

CONFIG += dll

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambacore.cpp \
    sambascript.cpp \
    sambaconnection.cpp \
    sambaconnectionport.cpp \
    sambaobject.cpp \
    sambaapplet.cpp \
    sambadevice.cpp \
    sambalogger.cpp

HEADERS += \
    sambacore.h\
    sambacore_global.h \
    sambascript.h \
    sambaconnection.h \
    sambaconnectionport.h \
    utils.h \
    sambaobject.h \
    sambaplugin.h \
    sambaapplet.h \
    sambadevice.h \
    sambalogger.h

unix:!mac{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_RPATH =
}

# install
target.path = /
INSTALLS += target

unix:!mac{
    QMAKE_RPATH=
}
