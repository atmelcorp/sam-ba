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

## Command Line

Alternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the serialflash-usb.qml script:

        sam-ba -p usb -b sama5d3-xplained -a lowlevel
        sam-ba -p usb -b sama5d3-xplained -a serialflash -c erase
        sam-ba -p usb -b sama5d3-xplained -a serialflash -c writeboot:application.bin

The following commands are equivalent to the serialflash-jlink.qml script:

        sam-ba -p jlink -b sama5d3-xplained -a lowlevel
        sam-ba -p jlink -b sama5d3-xplained -a serialflash -c erase
        sam-ba -p jlink -b sama5d3-xplained -a serialflash -c writeboot:application.bin
