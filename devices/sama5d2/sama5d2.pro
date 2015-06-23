TEMPLATE = aux

DEVICE_FILES *= \
    SAMA5D2.qml \
    SAMA5D2/applet-lowlevel-sama5d2.bin \
    SAMA5D2/applet-serialflash-sama5d2.bin

DISTFILES += $$DEVICE_FILES

include(../devices.pri)
