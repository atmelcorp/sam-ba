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
    SAMA5D2SDMMCApplet.qml \
    SAMA5D2SerialFlashApplet.qml \
    sama5d2-bcw.js \
    sama5d2-bootcfg.js \
    sama5d2-bscr.js \
    applets/applet-bootconfig_sama5d2-generic_sram.bin \
    applets/applet-lowlevel_sama5d2-generic_sram.bin \
    applets/applet-nandflash_sama5d2-generic_sram.bin \
    applets/applet-qspiflash_sama5d2-generic_sram.bin \
    applets/applet-sdmmc_sama5d2-generic_sram.bin \
    applets/applet-serialflash_sama5d2-generic_sram.bin

include(../device.pri)

metadata.files = device_sama5d2.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sama5d2.qdoc
