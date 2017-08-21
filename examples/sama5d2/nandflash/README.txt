# SAMA5D2 NANDFlash Example

Sample scripts to flash a linux environment on NANDFlash of the
"SAMA5D2 PTC ENGI" board.

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

        sam-ba -p usb -b sama5d2-xplained -a nandflash -c erase
        sam-ba -p usb -b sama5d2-xplained -a nandflash -c writeboot:at91bootstrap.bin
        sam-ba -p usb -b sama5d2-xplained -a nandflash -c write:u-boot-env.bin:0x4000
        sam-ba -p usb -b sama5d2-xplained -a nandflash -c write:u-boot.bin:0x8000
        sam-ba -p usb -b sama5d2-xplained -a nandflash -c write:at91-sama5d2_xplained.dtb:0x60000
        sam-ba -p usb -b sama5d2-xplained -a nandflash -c write:zImage:0x6c000
        sam-ba -p usb -b sama5d2-xplained -a bootconfig -c writecfg:bscr:valid,bureg0
        sam-ba -p usb -b sama5d2-xplained -a bootconfig -c writecfg:bureg0:ext_mem_boot,sdmmc1_disabled,sdmmc0_disabled,nfc_ioset2,spi1_disabled,spi0_disabled,qspi1_disabled,qspi0_disabled

The following commands are equivalent to the nandflash-jlink.qml script:

        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c erase
        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c writeboot:at91bootstrap.bin
        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c write:u-boot-env.bin:0x4000
        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c write:u-boot.bin:0x8000
        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c write:at91-sama5d2_xplained.dtb:0x60000
        sam-ba -p jlink -b sama5d2-xplained -a nandflash -c write:zImage:0x6c000
        sam-ba -p jlink -b sama5d2-xplained -a bootconfig -c writecfg:bscr:valid,bureg0
        sam-ba -p jlink -b sama5d2-xplained -a bootconfig -c writecfg:bureg0:ext_mem_boot,sdmmc1_disabled,sdmmc0_disabled,nfc_ioset2,spi1_disabled,spi0_disabled,qspi1_disabled,qspi0_disabled
