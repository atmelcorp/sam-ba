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
    sambabytearray.cpp \
    sambautils.cpp

HEADERS += \
    sambacommon.h \
    sambaengine.h\
    sambabytearray.h \
    sambautils.h

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
