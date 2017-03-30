# SAMA5D3 NANDFlash Example

Sample scripts to flash a linux environment on NANDFlash of the
"SAMA5D3 XPLAINED" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x nandflash-usb.qml
    On Linux:
        ../../../sam-ba -x nandflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x nandflash-jlink.qml
    On Linux:
        ../../../sam-ba -x nandflash-jlink.qml

## Command Line

Alternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the nandflash-usb.qml script:

        sam-ba -p usb -b sama5d3-xplained -a lowlevel
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c erase
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c writeboot:at91bootstrap-sama5d3_xplained.bin
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c write:u-boot-sama5d3-xplained.bin:0x40000
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c write:u-boot-env-sama5d3-xplained.bin:0xc0000
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c write:at91-sama5d3_xplained.dtb:0x180000
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c write:zImage-sama5d3-xplained.bin:0x200000
        sam-ba -p usb -b sama5d3-xplained -a nandflash -c write:atmel-xplained-demo-image-sama5d3-xplained.ubi:0x800000

The following commands are equivalent to the nandflash-jlink.qml script:

        sam-ba -p jlink -b sama5d3-xplained -a lowlevel
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c erase
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c writeboot:at91bootstrap-sama5d3_xplained.bin
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c write:u-boot-sama5d3-xplained.bin:0x40000
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c write:u-boot-env-sama5d3-xplained.bin:0xc0000
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c write:at91-sama5d3_xplained.dtb:0x180000
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c write:zImage-sama5d3-xplained.bin:0x200000
        sam-ba -p jlink -b sama5d3-xplained -a nandflash -c write:atmel-xplained-demo-image-sama5d3-xplained.ubi:0x800000
