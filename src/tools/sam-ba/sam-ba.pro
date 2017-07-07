TEMPLATE = app
CONFIG += console
CONFIG -= app_bundle
QT += core qml quick

TARGET = sam-ba

VERSION = 3.2.0
EXTRAVERSION = -rc3
DEFINES += SAMBA_VERSION=\\\"$$VERSION$$EXTRAVERSION\\\"

SOURCES += \
    main.cpp \
    sambatool.cpp

HEADERS += \
    sambatool.h \
    sambatoolcontext.h \
    sambascriptcontext.h

# include/link sambacommon library
INCLUDEPATH += $$PWD/../../sambacommon
DEPENDPATH += $$PWD/../../sambacommon
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../../sambacommon/release/ -lsambacommon3
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../../sambacommon/debug/ -lsambacommon3
else:unix: LIBS += -L$$OUT_PWD/../../sambacommon/ -lsambacommon

# set RPATH on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath-link,$$[QT_INSTALL_LIBS]'
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/lib\''
    QMAKE_RPATH =
}

qml.files = \
	qmldir \
	AppletCommandHandler.qml \
	MonitorCommandHandler.qml
qml.path = /qml/SAMBA/Tool

# install executable
target.path = /
INSTALLS += target qml
