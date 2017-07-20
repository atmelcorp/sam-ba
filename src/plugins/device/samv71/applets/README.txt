These SAMV71 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: b1a4c40bf9c61e47a4e6bb3a816d89b20e8681e1

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout b1a4c40bf9c61e47a4e6bb3a816d89b20e8681e1

2. build the applet (for example: internalflash):
        cd samba_applets/internalflash
        make TARGET=samv71-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-internalflash_samv71-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMV71/applets

