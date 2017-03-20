TEMPLATE = aux

DEVICE = SAM9xx5

DEVICE_FILES *= \
    qmldir \
    SAM9xx5.qml \
    SAM9xx5Config.qml \
    SAM9xx5EK.qml \
    applets/README.txt \
    applets/applet-lowlevel_sam9x25-generic_sram.bin \
    applets/applet-extram_sam9x25-generic_sram.bin \
    applets/applet-nandflash_sam9x25-generic_ddram.bin \
    applets/applet-sdmmc_sam9x25-generic_ddram.bin \
    applets/applet-serialflash_sam9x25-generic_ddram.bin

include(../device.pri)

metadata.files = \
    device_sam9xx5.json \
    board_sam9xx5-ek.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sam9xx5.qdoc
