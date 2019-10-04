These SAM9X60 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: a730b4351efc9e37aa2153782ca04b5445d7c73b

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout a730b4351efc9e37aa2153782ca04b5445d7c73b

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sam9x60-generic VARIANT=sram RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sam9x60-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAM9X60/applets

