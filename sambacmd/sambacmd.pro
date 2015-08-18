TEMPLATE = app

QT -= gui
QT += core qml

TARGET = sambacmd

CONFIG += console
CONFIG -= app_bundle
CONFIG(debug, debug|release):CONFIG += qml_debug

SOURCES += main.cpp

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../sambacore/release/ -lsambacore3
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../sambacore/debug/ -lsambacore3
else:unix: LIBS += -L$$OUT_PWD/../sambacore/ -lsambacore

# set RPATH to $ORIGIN on Linux
unix:!mac{
    QMAKE_LFLAGS += '-Wl,-rpath,\'\$$ORIGIN\''
    QMAKE_RPATH =
}

INCLUDEPATH += $$PWD/../sambacore
DEPENDPATH += $$PWD/../sambacore

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/../devices

# install executable
target.path = /
INSTALLS += target
