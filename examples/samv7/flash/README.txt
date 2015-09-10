# SAMV7 Flash Example

Sample script to flash a binary to a SAMV7 device

## Setup

- Adapt the qml script file for your application (file to flash, address)

## Flashing using USB

- Boot the device in ROM mode (either by erasing flash or setting GPNVM1 to 0)
- Connect and power the board using the "Target USB" connector
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x write-flash-usb.qml
    On Linux:
        ../../../sam-ba -x write-flash-usb.qml
