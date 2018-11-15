TEMPLATE = aux

DEVICE = SAMA5D4

DEVICE_FILES *= \
    qmldir \
    SAMA5D4.qml \
    SAMA5D4Config.qml \
    SAMA5D4EK.qml \
    SAMA5D4Xplained.qml \
    applets/README.txt \
    applets/applet-extram_sama5d4-generic_sram.bin \
    applets/applet-lowlevel_sama5d4-generic_sram.bin \
    applets/applet-nandflash_sama5d4-generic_sram.bin \
    applets/applet-reset_sama5d4-generic_sram.bin \
    applets/applet-sdmmc_sama5d4-generic_sram.bin \
    applets/applet-serialflash_sama5d4-generic_sram.bin \
    applets/applet-extram_sama5d4-generic_sram.cip \
    applets/applet-lowlevel_sama5d4-generic_sram.cip \
    applets/applet-nandflash_sama5d4-generic_sram.cip \
    applets/applet-reset_sama5d4-generic_sram.cip \
    applets/applet-sdmmc_sama5d4-generic_sram.cip \
    applets/applet-serialflash_sama5d4-generic_sram.cip

include(../device.pri)

metadata.files = \
    device_sama5d4.json \
    board_sama5d4-ek.json \
    board_sama5d4-xplained.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sama5d4.qdoc
