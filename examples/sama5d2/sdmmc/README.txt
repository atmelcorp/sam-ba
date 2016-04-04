# SAMA5D2 SD/MMC Example

Sample scripts to flash data on SD/MMC or eMMC for the "SAMA5D2 XPLAINED ULTRA"
board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x emmc-usb.qml
    On Linux:
        ../../../sam-ba -x emmc-usb.qml

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x emmc-jlink.qml
    On Linux:
        ../../../sam-ba -x emmc-jlink.qml

