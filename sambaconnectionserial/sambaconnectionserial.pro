TEMPLATE = lib

QT -= gui
QT += core serialport qml

TARGET = sambaconnectionserial

CONFIG += plugin

SOURCES += \
    sambaconnectionserialplugin.cpp \
    sambaconnectionserial.cpp \
    sambaconnectionportserial.cpp

HEADERS += \
    sambaconnectionserial.h \
    sambaconnectionportserial.h \
    sambaconnectionpluginserial.h

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../sambacore/release/ -lsambacore3
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../sambacore/debug/ -lsambacore3
else:unix: LIBS += -L$$OUT_PWD/../sambacore/ -lsambacore

INCLUDEPATH += $$PWD/../sambacore
DEPENDPATH += $$PWD/../sambacore

# install
target.path = /plugins
INSTALLS += target

unix:!mac{
    QMAKE_RPATH=
}
