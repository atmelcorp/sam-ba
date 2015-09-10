TEMPLATE = aux

DEVICE = SAMA5D2

DEVICE_FILES *= \
    qmldir \
    SAMA5D2.qml \
    SAMA5D2Config.qml \
    sama5d2-boot-cfg.js \
    applets/applet-lowlevel-sama5d2.bin \
    applets/applet-serialflash-sama5d2.bin \
    applets/applet-qspiflash-sama5d2.bin

include(../device.pri)

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sama5d2.qdoc
