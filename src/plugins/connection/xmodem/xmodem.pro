TEMPLATE = lib
CONFIG += dll
QT += core serialport

TARGET = samba_conn_xmodem

win32: DESTPATH = /
else:unix: DESTPATH = /lib

SOURCES += xmodemhelper.cpp
HEADERS += xmodemhelper.h

# set RPATH on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_RPATH =
}

# install
target.path = $$DESTPATH
INSTALLS *= target
