TEMPLATE = aux

DEVICE = SAMA5D3

DEVICE_FILES *= \
    qmldir \
    SAMA5D3Config.qml \
    SAMA5D3.qml \
    applets/README.txt \
    applets/applet-lowlevel_sama5d3-generic_sram.bin \
    applets/applet-nandflash_sama5d3-generic_sram.bin \
    applets/applet-serialflash_sama5d3-generic_sram.bin

include(../device.pri)

metadata.files = device_sama5d3.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_sama5d3.qdoc
