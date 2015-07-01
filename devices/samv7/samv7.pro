TEMPLATE = aux

DEVICE_FILES *= \
    samv7.qml \
    samv7/applet-lowlevelinit-samv7.bin \
    samv7/applet-flash-samv7.bin

DISTFILES += $$DEVICE_FILES

include(../devices.pri)
