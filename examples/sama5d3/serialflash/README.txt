# SAMA5D3 SerialFlash Example

Sample scripts to flash an application on SPI SerialFlash of the
"SAMA5D3 XPLAINED" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x serialflash-usb.qml
    On Linux:
        ../../../sam-ba -x serialflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x serialflash-jlink.qml
    On Linux:
        ../../../sam-ba -x serialflash-jlink.qml

