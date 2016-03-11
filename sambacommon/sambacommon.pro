TEMPLATE = lib
CONFIG += dll
QT += core qml quick

TARGET = sambacommon

VERSION = 3.0.0

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambaabstractapplet.cpp \
    sambabytearray.cpp \
    sambacommon.cpp \
    sambaconnection.cpp \
    sambaengine.cpp \
    sambautils.cpp

HEADERS += \
    sambaabstractapplet.h \
    sambabytearray.h \
    sambacommon.h \
    sambaconnection.h \
    sambaengine.h\
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
	type_baseapplet.qdoc \
	type_bytearray.qdoc \
	type_utils.qdoc
