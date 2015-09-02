TEMPLATE = aux

DEVICE = SAMV7

DEVICE_FILES *= \
    qmldir \
    SAMV7.qml \
    applets/applet-lowlevelinit-samv7.bin \
    applets/applet-flash-samv7.bin

DISTFILES += $$DEVICE_FILES

include(../device.pri)
