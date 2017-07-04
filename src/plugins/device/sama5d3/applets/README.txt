These SAMA5D4 Applets were built from the Atmel Software Package:

Repository: https://github.com/atmelcorp/atmel-software-package
Commit: a3764374724ea6e83696998291e671a86e6e4537

To get the sources and rebuild an applet (using GCC):

1. get the software package source git checkout:
        git clone https://github.com/atmelcorp/atmel-software-package
        git checkout a3764374724ea6e83696998291e671a86e6e4537

2. build the applet (for example: serialflash):
        cd samba_applets/serialflash
        make TARGET=sama5d3-generic RELEASE=1

3. copy the applet binary to SAM-BA directory
        cp build/applet-serialflash_sama5d3-generic_sram.bin $SAMBADIR/qml/SAMBA/Device/SAMA5D3/applets

