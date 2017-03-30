# NANDFlash Example

Sample scripts to flash a linux environment on NANDFlash of the
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
        ..\..\..\sam-ba -x nandflash-usb.qml
    On Linux:
        ../../../sam-ba -x nandflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Move SW1 to off.
- Power the board
- Connect USB using the "USB-A" connector
- Move SW1 to on
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x nandflash-jlink.qml
    On Linux:
        ../../../sam-ba -x nandflash-jlink.qml

## Command Line

Alternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the nandflash-usb.qml script:

        sam-ba -p usb -b sam9xx5-ek -a lowlevel
        sam-ba -p usb -b sam9xx5-ek -a extram
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c erase
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c writeboot:at91bootstrap-sam9-ek.bin
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c write:u-boot-sam9-ek.bin:0x40000
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c write:u-boot-env-sam9-ek.bin:0xc0000
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c write:at91-sam9-ek.dtb:0x180000
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c write:zImage-sam9-ek.bin:0x200000
        sam-ba -p usb -b sam9xx5-ek -a nandflash -c write:atmel-xplained-demo-image-sam9-ek.ubi:0x800000

The following commands are equivalent to the nandflash-jlink.qml script:

        sam-ba -p jlink -b sam9xx5-ek -a lowlevel
        sam-ba -p jlink -b sam9xx5-ek -a extram
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c erase
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c writeboot:at91bootstrap-sam9-ek.bin
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c write:u-boot-sam9-ek.bin:0x40000
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c write:u-boot-env-sam9-ek.bin:0xc0000
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c write:at91-sam9-ek.dtb:0x180000
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c write:zImage-sam9-ek.bin:0x200000
        sam-ba -p jlink -b sam9xx5-ek -a nandflash -c write:atmel-xplained-demo-image-sam9-ek.ubi:0x800000
