TEMPLATE = aux

DEVICE = SAMA5D2

DEVICE_FILES *= \
    qmldir \
    SAMA5D2.qml \
    sama5d2-boot-cfg.js \
    applets/applet-lowlevel-sama5d2.bin \
    applets/applet-serialflash-sama5d2.bin \
    applets/applet-qspiflash-sama5d2.bin

DISTFILES += $$DEVICE_FILES

include(../device.pri)
