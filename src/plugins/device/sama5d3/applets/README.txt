These SAMA5D3 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: 65146d0e62565d23acaa80354ce7a329f2a1137d

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout 65146d0e62565d23acaa80354ce7a329f2a1137d

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sama5d3-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sama5d3-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMA5D3/applets

