# examples/sama5d2-serialflash

Sample scripts to flash a linux environment on the "SAMA5D2 XPLAINED ULTRA" board.

## Setup

- Adapt the qml script file for your application (files to flash / offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open the "BOOT_DIS" jumper
- Run "write-serialflash-usb.sh" script (or "write-serialflash-usb.bat" for Windows)

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open the "BOOT_DIS" jumper
- Run "write-serialflash-jlink.sh" script (or "write-serialflash-jlink.bat" for Windows)

