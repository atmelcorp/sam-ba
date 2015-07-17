# examples/sama5d2-qspiflash

Sample scripts to flash a linux environment on the QSPI Flash of the
"SAMA5D2 XPLAINED ULTRA" board.

## Setup

- Adapt the qml script file for your application (files to flash and offsets)

## Flashing using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run "write-qspiflash-usb.sh" script (or "write-qspiflash-usb.bat" for
Windows)

## Flashing using SEGGER J-Link adapter

- Close "BOOT_DIS" jumper
- Connect J-Link to "A5-JTAG" connector
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run "write-qspiflash-jlink.sh" script (or "write-qspiflash-jlink.bat" for
Windows)
