import SAMBA 1.0

Device {
    tag: "sama5d2"
    name: "SAMA5D2"

    applets: [
        Applet {
            id: lowlevel
            enabled: true
            kind: Applet.Lowlevel
            tag: "lowlevel"
            name: "Low-Level"
            fileName: "file:///home/llefort/Documents/src/softpack/sama5d2/samba_applets/lowlevel/d2/applet-lowlevel-sama5d2.bin"
            //fileName: Qt.resolvedUrl("SAMA5D2/applet-lowlevel-sama5d2.bin")
            appletAddress: 0x220000
            mailboxAddress: 0x220004
        },
        Applet {
            enabled: lowlevel.initialized
            kind: Applet.NVM
            tag: "serialflash"
            name: "AT25/AT26 Serial Flash"
            fileName: "file:///home/llefort/Documents/src/softpack/sama5d2/samba_applets/serialflash/d2/applet-serialflash-sama5d2.bin"
            //fileName: Qt.resolvedUrl("SAMA5D2/applet-serialflash-sama5d2.bin")
            appletAddress: 0x220000
            mailboxAddress: 0x220004
        }
    ]
}
