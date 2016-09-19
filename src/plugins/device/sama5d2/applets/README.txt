These SAMA5D2 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: b66444ae4e1320d31faec67b28cdade57d60afa0 (tag v2.5)

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout b66444ae4e1320d31faec67b28cdade57d60afa0

2. build the applet (for example: qspiflash):
        cd samba_applets/qspiflash
        make TARGET=sama5d2-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-qspiflash_sama5d2-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMA5D2/applets

