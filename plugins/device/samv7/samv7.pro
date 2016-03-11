TEMPLATE = aux

DEVICE = SAMV7

DEVICE_FILES *= \
    qmldir \
    SAMV7.qml \
    applets/applet-lowlevelinit-samv7.bin \
    applets/applet-flash-samv7.bin

include(../device.pri)

metadata.files = device_samv7.json
metadata.path = /metadata
INSTALLS *= metadata

OTHER_FILES += \
    $$DEVICE_FILES \
    module_samba_device_samv7.qdoc
