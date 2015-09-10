# SAMA5D2 Boot Configuration example

Sample scripts to display or configure the Boot Configuration Word in GPBR and/or Fuses.

## Configuration

Adapt the set-boot-config.qml script file for your application (see TODO note inside QML script).

## Running using USB

- Close "BOOT_DIS" jumper
- Connect and power the board using the "A5-USB-A" USB connector
- Open "BOOT_DIS" jumper
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x show-boot-config.qml
    On Linux:
        ../../../sam-ba -x show-boot-config.qml
