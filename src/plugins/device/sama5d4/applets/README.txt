These SAMA5D4 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: b1a4c40bf9c61e47a4e6bb3a816d89b20e8681e1

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout b1a4c40bf9c61e47a4e6bb3a816d89b20e8681e1

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sama5d4-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sama5d4-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMA5D4/applets

