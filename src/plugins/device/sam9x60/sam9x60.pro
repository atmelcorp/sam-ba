TEMPLATE = aux

DEVICE = SAM9X60

DEVICE_FILES *= \
    qmldir \
    SAM9X60.qml \
    SAM9X60BootConfigApplet.qml \
    SAM9X60Config.qml \
    SAM9X60LowlevelApplet.qml \
    SAM9X60LowlevelConfig.qml \
    sam9x60-bcp.js \
    sam9x60-bootcfg.js \
    sam9x60-bscr.js \
    sam9x60-uhcp.js \
    applets/README.txt \
    applets/applet-bootconfig_sam9x60-generic_sram.bin \
    applets/applet-extram_sam9x60-generic_sram.bin \
    applets/applet-lowlevel_sam9x60-generic_sram.bin \
    applets/applet-nandflash_sam9x60-generic_ddram.bin \
    applets/applet-qspiflash_sam9x60-generic_ddram.bin \
    applets/applet-reset_sam9x60-generic_sram.bin \
    applets/applet-sdmmc_sam9x60-generic_ddram.bin \
    applets/applet-serialflash_sam9x60-generic_ddram.bin

include(../device.pri)

metadata.files = \
    device_sam9x60.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sam9x60.qdoc
