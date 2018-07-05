TEMPLATE = aux

qml.files = \
    qmldir \
    BootConfigApplet.qml \
    ExtRamApplet.qml \
    ExtRamConfig.qml \
    InternalFlashApplet.qml \
    InternalRCApplet.qml \
    LowlevelApplet.qml \
    LowlevelConfig.qml \
    NANDFlashApplet.qml \
    NANDFlashConfig.qml \
    QSPIFlashApplet.qml \
    QSPIFlashConfig.qml \
    ResetApplet.qml \
    SDMMCApplet.qml \
    SDMMCConfig.qml \
    SerialConfig.qml \
    SerialFlashApplet.qml \
    SerialFlashConfig.qml

qml.path = /qml/SAMBA/Applet

INSTALLS *= qml

OTHER_FILES += \
    module_samba_applet.qdoc
