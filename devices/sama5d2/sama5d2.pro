TEMPLATE = aux

DEVICE_FILES *= \
    sama5d2.qml \
    sama5d2/applet-lowlevel-sama5d2.bin \
    sama5d2/applet-serialflash-sama5d2.bin

DISTFILES += $$DEVICE_FILES

include(../devices.pri)
