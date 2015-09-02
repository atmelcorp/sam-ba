TEMPLATE = lib

QT -= gui
QT += qml

TARGET = sambacommon

VERSION = 3.0.0

CONFIG += dll

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambacommon.cpp \
    sambaengine.cpp \
    sambascript.cpp \
    sambaconnection.cpp \
    sambaconnectionport.cpp \
    sambaobject.cpp \
    sambaapplet.cpp \
    sambadevice.cpp \
    sambalogger.cpp

HEADERS += \
    sambacommon.h\
    sambaengine.h \
    sambascript.h \
    sambaconnection.h \
    sambaconnectionport.h \
    utils.h \
    sambaobject.h \
    sambaplugin.h \
    sambaapplet.h \
    sambadevice.h \
    sambalogger.h

unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_RPATH =
    target.path = /lib
}
else:win32:{
    target.path = /
}

# install
INSTALLS += target
