TEMPLATE = lib
CONFIG += plugin
QT += core serialport qml quick

TARGET = samba_conn_serial

DESTPATH = /qml/SAMBA/Connection/Serial

SOURCES += sambaconnectionserialhelper.cpp \
    xmodemhelper.cpp
HEADERS += sambaconnectionserialhelper.h \
    xmodemhelper.h

# set RPATH on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../../../lib\''
    QMAKE_RPATH =
}

qml.files = \
	qmldir \
	SerialConnection.qml

metadata.files = \
	connection_serial.json

# install
target.path = $$DESTPATH
qml.path = $$DESTPATH
metadata.path = /metadata
INSTALLS *= target qml metadata

OTHER_FILES += \
    $$qml.files \
    module_samba_connection_serial.qdoc
