TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
QT += core qml quick

TARGET = sam-ba

VERSION = 3.2.2
EXTRAVERSION =
DEFINES += SAMBA_VERSION=\\\"$$VERSION$$EXTRAVERSION\\\"

SOURCES += \
    main.cpp \
    sambacomponent.cpp \
    sambaengine.cpp \
    sambametadata.cpp \
    sambatool.cpp

HEADERS += \
    sambacomponent.h \
    sambaengine.h \
    sambametadata.h \
    sambatool.h \
    sambatoolcontext.h

# set RPATH on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath-link,$$[QT_INSTALL_LIBS]'
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/lib\''
    QMAKE_RPATH =
}

qml.files = \
	qmldir \
	AppletCommandHandler.qml \
	MonitorCommandHandler.qml \
	ScriptProxy.qml
qml.path = /qml/SAMBA/Tool

# install executable
target.path = /
INSTALLS += target qml
