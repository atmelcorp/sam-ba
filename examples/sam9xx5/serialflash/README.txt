# SerialFlash Example

Sample scripts to flash a linux environment on SerialFlash of the
"SAM9XX5-EK" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Move SW1 to off.
- Power the board
- Connect USB using the "USB-A" connector
- Move SW1 to on
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x serialflash-usb.qml
    On Linux:
        ../../../sam-ba -x serialflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Move SW1 to off.
- Power the board
- Connect USB using the "USB-A" connector
- Move SW1 to on
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x serialflash-jlink.qml
    On Linux:
        ../../../sam-ba -x serialflash-jlink.qml

## Command Line

Alternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the serialflash-usb.qml script:

        sam-ba -p usb -b sam9xx5-ek -a lowlevel
        sam-ba -p usb -b sam9xx5-ek -a extram
        sam-ba -p usb -b sam9xx5-ek -a serialflash -c erase
        sam-ba -p usb -b sam9xx5-ek -a serialflash -c writeboot:application.bin

The following commands are equivalent to the serialflash-jlink.qml script:

        sam-ba -p jlink -b sam9xx5-ek -a lowlevel
        sam-ba -p jlink -b sam9xx5-ek -a extram
        sam-ba -p jlink -b sam9xx5-ek -a serialflash -c erase
        sam-ba -p jlink -b sam9xx5-ek -a serialflash -c writeboot:application.bin
