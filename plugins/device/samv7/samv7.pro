TEMPLATE = aux

DEVICE_FILES *= \
    samv7.qml \
    appplets/applet-lowlevelinit-samv7.bin \
    appplets/applet-flash-samv7.bin

DISTFILES += $$DEVICE_FILES

include(../device.pri)
