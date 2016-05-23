These SAMA5D4 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: a2c9edd1b0cb333c848eb10dcfb0432fb2459cd7 (tag v2.1)

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout TODO

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sama5d4-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sama5d4-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMA5D4/applets

