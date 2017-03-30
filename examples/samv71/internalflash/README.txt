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

## Command Line

Alternatively, it is possible to use command-line commands instead of the QML script.

The following commands are equivalent to the internalflash-usb.qml script:

        sam-ba -p usb -b samv71-xplained -a internalflash -c erase -c write:program.bin
        sam-ba -p usb -b samv71-xplained -a bootconfig -c writecfg:bootmode:flash

The following commands are equivalent to the internalflash-jlink.qml script:

        sam-ba -p jlink::swd -b samv71-xplained -a internalflash -c erase -c write:program.bin
        sam-ba -p jlink::swd -b samv71-xplained -a bootconfig -c writecfg:bootmode:flash

The following command uses the JTAG connection to reset the bootmode to the SAM-BA Monitor:

        sam-ba -p jlink::swd -b samv71-xplained -a bootconfig -c writecfg:bootmode:monitor
