These SAM9xx5 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: 8798f307abc4528411a619722c983dfdab06007d

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout 8798f307abc4528411a619722c983dfdab06007d

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sam9x25-generic VARIANT=ddram RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sam9x25-generic_ddram.bin $SAMBADIR/qml/SAMBA/Device/SAM9xx5/applets

