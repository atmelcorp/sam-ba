TEMPLATE = lib
CONFIG += dll
QT += core qml quick

TARGET = sambacommon

VERSION = 3.0.0

DEFINES += SAMBACOMMON_LIBRARY

SOURCES += \
    sambacommon.cpp \
    sambaengine.cpp \
    sambabytearray.cpp \
    sambautils.cpp \
    sambaconnection.cpp \
    sambaapplet.cpp

HEADERS += \
    sambacommon.h \
    sambaengine.h\
    sambabytearray.h \
    sambautils.h \
    sambaconnection.h \
    sambaapplet.h

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
	type_applet.qdoc \
	type_bytearray.qdoc \
	type_connection.qdoc \
	type_utils.qdoc
