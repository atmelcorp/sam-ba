TEMPLATE = lib
CONFIG += dll
QT += core qml quick

TARGET = sambacommon

VERSION = 3.2.0

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambacommon.cpp \
    sambaengine.cpp \
    sambafile.cpp \
    sambafileinstance.cpp \
    sambautils.cpp

HEADERS += \
    sambacommon.h \
    sambaengine.h \
    sambafile.h \
    sambafileinstance.h \
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
