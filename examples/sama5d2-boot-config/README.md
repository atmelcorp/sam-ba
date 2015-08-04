# sama5d2-boot-config

Sample script to configyre the Boot Configuration Word in GPBR and/or Fuses.

## Setup

- Adapt the qml script file for your application (see TODO note in QML script)
- Make sure that the helper javascript library 'sama5d2-boot-config.js' is
  located in the same directory as the QML script.

## Running using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run "sama5d2-set-boot-config.sh" script (or "sama5d2-set-boot-config.bat" for
  Windows)
