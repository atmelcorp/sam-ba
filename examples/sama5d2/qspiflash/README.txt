# SAMA5D2 QuadSPI Flash Example

Sample scripts to flash a linux environment on the QSPI Flash of the
"SAMA5D2 XPLAINED ULTRA" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-usb.qml
    On Linux:
        ../../../sam-ba -x qspiflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x qspiflash-jlink.qml
    On Linux:
        ../../../sam-ba -x qspiflash-jlink.qml

