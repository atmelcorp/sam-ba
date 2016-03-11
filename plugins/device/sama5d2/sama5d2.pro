TEMPLATE = aux

DEVICE = SAMA5D2

DEVICE_FILES *= \
    qmldir \
    SAMA5D2Config.qml \
    SAMA5D2.qml \
    SAMA5D2BootConfigApplet.qml \
    SAMA5D2LowlevelApplet.qml \
    SAMA5D2NANDFlashApplet.qml \
    SAMA5D2QSPIFlashApplet.qml \
    SAMA5D2SerialFlashApplet.qml \
    sama5d2-bcw.js \
    sama5d2-bootcfg.js \
    sama5d2-bscr.js \
    applets/applet-bootconfig-sama5d2.bin \
    applets/applet-lowlevel-sama5d2.bin \
    applets/applet-nandflash-sama5d2.bin \
    applets/applet-qspiflash-sama5d2.bin \
    applets/applet-serialflash-sama5d2.bin

include(../device.pri)

metadata.files = device_sama5d2.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sama5d2.qdoc
