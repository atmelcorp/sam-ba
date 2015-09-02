TEMPLATE = aux

DEVICE_FILES *= \
    sama5d2.qml \
    applets/applet-lowlevel-sama5d2.bin \
    applets/applet-serialflash-sama5d2.bin \
    applets/applet-qspiflash-sama5d2.bin

DISTFILES += $$DEVICE_FILES

include(../device.pri)
