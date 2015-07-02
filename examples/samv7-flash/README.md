# examples/samv7-flash

Sample script to flash a binary to a SAMV7 device

## Setup

- Adapt the qml script file for your application (file to flash, address)

## Flashing using USB

- Boot the device in ROM mode (either by erasing flash or setting GPNVM1 to 0)
- Connect and power the board using the "Target USB" connector
- Run "write-flash-usb.sh" script (or "write-flash-usb.bat" for Windows)

