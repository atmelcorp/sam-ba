# SAM9X60 SDMMC Example

Sample scripts to flash a linux environment on SD Card of the
"SAM9X60 Evaluation Kit" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Plug a USB cable between your PC and the "USB Device" connector of the board
- Push and hold the "BOOT_DIS" button
- Power-on or reset the board
- Release the "BOOT_DIS" button
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x sdmmc-usb.qml
    On Linux:
        ../../../sam-ba -x sdmmc-usb.qml

## Flashing using SEGGER J-Link adapter

- Plug your J-Link adapter to the JTAG header
- Power-on the board
- Run the qml script using the sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x sdmmc-jlink.qml
    On Linux:
        ../../../sam-ba -x sdmmc-jlink.qml

## Command Line

Aternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the sdmmc-usb.qml script:

        sam-ba -p serial -b sam9x60-ek -a lowlevel
        sam-ba -p serial -b sam9x60-ek -a extram
        sam-ba -p serial -b sam9x60-ek -a sdmmc -c write:sdcard.img

The following commands are equivalent to the sdmmc-jlink.qml script:

        sam-ba -p j-link -b sam9x60-ek -a lowlevel
        sam-ba -p j-link -b sam9x60-ek -a extram
        sam-ba -p j-link -b sam9x60-ek -a nandflash -c write:sdcard.img
