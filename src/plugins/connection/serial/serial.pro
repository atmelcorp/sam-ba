TEMPLATE = lib
CONFIG += plugin
QT += core serialport qml quick

TARGET = samba_conn_serial

DESTPATH = /qml/SAMBA/Connection/Serial

SOURCES += sambaconnectionserialhelper.cpp
HEADERS += sambaconnectionserialhelper.h

INCLUDEPATH += $$PWD/../xmodem
DEPENDPATH += $$PWD/../xmodem

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../xmodem/release -lsamba_conn_xmodem
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../xmodem/debug -lsamba_conn_xmodem
else:unix: LIBS += -L$$OUT_PWD/../xmodem -lsamba_conn_xmodem

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
