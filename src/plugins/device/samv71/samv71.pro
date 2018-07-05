TEMPLATE = aux

DEVICE = SAMV71

DEVICE_FILES *= \
    qmldir \
    SAME70Xplained.qml \
    SAMV71.qml \
    SAMV71BootConfigApplet.qml \
    SAMV71Config.qml \
    SAMV71Xplained.qml \
    samv71-bootcfg.js \
    applets/applet-bootconfig_samv71-generic_sram.bin \
    applets/applet-extram_samv71-generic_sram.bin \
    applets/applet-internalflash_samv71-generic_sram.bin \
    applets/applet-lowlevel_samv71-generic_sram.bin \
    applets/applet-reset_samv71-generic_sram.bin

include(../device.pri)

metadata.files = \
    board_same70-xplained.json \
    board_samv71-xplained.json \
    device_samv71.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_samv71.qdoc
