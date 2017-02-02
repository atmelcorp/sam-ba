TEMPLATE = aux

qml.files = \
    qmldir \
    ExtRamApplet.qml \
    ExtRamConfig.qml \
    LowlevelApplet.qml \
    LowlevelConfig.qml \
    NANDFlashApplet.qml \
    NANDFlashConfig.qml \
    QSPIFlashApplet.qml \
    QSPIFlashConfig.qml \
    SDMMCApplet.qml \
    SDMMCConfig.qml \
    SerialFlashApplet.qml \
    SerialFlashConfig.qml

qml.path = /qml/SAMBA/Applet

INSTALLS *= qml

OTHER_FILES += \
    module_samba_applet.qdoc
