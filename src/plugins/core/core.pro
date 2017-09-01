TEMPLATE = lib
CONFIG += plugin
QT += core qml quick

TARGET = samba_core

DESTPATH = /qml/SAMBA

SOURCES += \
    sambacore.cpp \
    sambacoreplugin.cpp \
    sambafile.cpp \
    sambafileinstance.cpp \
    sambautils.cpp
HEADERS += \
    sambacore.h \
    sambacoreplugin.h \
    sambafile.h \
    sambafileinstance.h \
    sambautils.h

# set RPATH on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/../../lib\''
    QMAKE_RPATH =
}

qml.files = qmldir \
    AppletCommand.qml \
    AppletConnectionType.js \
    Applet.qml \
    Connection.qml \
    Device.qml \
    Utils.qml \
    Script.qml

# install
target.path = $$DESTPATH
qml.path = $$DESTPATH
INSTALLS += target qml

OTHER_FILES += \
    $$qml.files \
    module_samba.qdoc \
    type_utils.qdoc
