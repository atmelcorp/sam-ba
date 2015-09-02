TEMPLATE = app

QT -= gui
QT += core qml

TARGET = sambacmd

CONFIG += console
CONFIG -= app_bundle
CONFIG(debug, debug|release):CONFIG += qml_debug

SOURCES += main.cpp

# include/link sambacommon library
INCLUDEPATH += $$PWD/../sambacommon
DEPENDPATH += $$PWD/../sambacommon
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../sambacommon/release/ -lsambacommon3
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../sambacommon/debug/ -lsambacommon3
else:unix: LIBS += -L$$OUT_PWD/../sambacommon/ -lsambacommon

# set RPATH to $ORIGIN on Linux
unix:!mac:{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN/lib\''
    QMAKE_RPATH =
}

# install executable
target.path = /
INSTALLS += target
