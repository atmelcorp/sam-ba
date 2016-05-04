TEMPLATE = lib
CONFIG += dll
QT += core qml quick

TARGET = sambacommon

VERSION = 3.1.0

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambaappletcommand.cpp \
    sambaapplet.cpp \
    sambabytearray.cpp \
    sambacommon.cpp \
    sambaconnection.cpp \
    sambadevice.cpp \
    sambaengine.cpp \
    sambautils.cpp

HEADERS += \
    sambaappletcommand.h \
    sambaapplet.h \
    sambabytearray.h \
    sambacommon.h \
    sambaconnection.h \
    sambadevice.h \
    sambaengine.h \
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

OTHER_FILES += \
	type_bytearray.qdoc
