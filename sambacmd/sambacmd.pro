TEMPLATE = app

QT -= gui
QT += core qml

TARGET = sambacmd.bin

CONFIG += console
CONFIG -= app_bundle
CONFIG(debug, debug|release):CONFIG += qml_debug

SOURCES += main.cpp

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../sambacore/release/ -lsambacore3
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../sambacore/debug/ -lsambacore3
else:unix: LIBS += -L$$OUT_PWD/../sambacore/ -lsambacore

INCLUDEPATH += $$PWD/../sambacore
DEPENDPATH += $$PWD/../sambacore

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH += $$PWD/../devices $$PWD/../qml

# install launch script
script.path = /
win32:script.files += sambacmd.bat
else:unix:script.files += sambacmd
INSTALLS += script

# install executable
target.path = /libs
INSTALLS += target

unix:!mac{
    QMAKE_RPATH=
}
