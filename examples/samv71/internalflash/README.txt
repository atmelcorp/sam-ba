# SAMV71 Internal Flash Example

Sample scripts to flash a program on the internal flash of the
"SAMV71 XPLAINED ULTRA" board.

## Setup

- Adapt the qml script file for your application (name of the file to flash)

## Flashing using USB

- Connect and power the board using the "TARGET USB" USB connector
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x internalflash-usb.qml
    On Linux:
        ../../../sam-ba -x internalflash-usb.qml

## Flashing using SEGGER J-Link adapter

- Connect J-Link to "SAMV71 DEBUG (SWD)" connector
- Connect and power the board using any power connector (VIN, TARGET USB or DEBUG USB)
- Run qml script using sam-ba tool, for example:
    On Windows:
        ..\..\..\sam-ba -x internalflash-jlink.qml
    On Linux:
        ../../../sam-ba -x internalflash-jlink.qml

