TEMPLATE = aux

DEVICE = SAM9X60

DEVICE_FILES *= \
    qmldir \
    SAM9X60.qml \
    SAM9X60BootConfigApplet.qml \
    SAM9X60Config.qml \
    SAM9X60EK.qml \
    SAM9X60LowlevelApplet.qml \
    SAM9X60LowlevelConfig.qml \
    SAM9X60SecureBootConfigApplet.qml \
    sam9x60-bcp.js \
    sam9x60-bootcfg.js \
    sam9x60-bscr.js \
    sam9x60-sbcp.js \
    sam9x60-uhcp.js \
    applets/README.txt \
    applets/applet-bootconfig_sam9x60-generic_sram.bin \
    applets/applet-extram_sam9x60-generic_sram.bin \
    applets/applet-lowlevel_sam9x60-generic_sram.bin \
    applets/applet-nandflash_sam9x60-generic_sram.bin \
    applets/applet-qspiflash_sam9x60-generic_sram.bin \
    applets/applet-reset_sam9x60-generic_sram.bin \
    applets/applet-sdmmc_sam9x60-generic_sram.bin \
    applets/applet-securebootconfig_sam9x60-generic_sram.bin \
    applets/applet-serialflash_sam9x60-generic_sram.bin \
    applets/applet-bootconfig_sam9x60-generic_sram.cip \
    applets/applet-extram_sam9x60-generic_sram.cip \
    applets/applet-lowlevel_sam9x60-generic_sram.cip \
    applets/applet-nandflash_sam9x60-generic_sram.cip \
    applets/applet-qspiflash_sam9x60-generic_sram.cip \
    applets/applet-reset_sam9x60-generic_sram.cip \
    applets/applet-sdmmc_sam9x60-generic_sram.cip \
    applets/applet-securebootconfig_sam9x60-generic_sram.cip \
    applets/applet-serialflash_sam9x60-generic_sram.cip

include(../device.pri)

metadata.files = \
    device_sam9x60.json \
    board_sam9x60-ek.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sam9x60.qdoc
