# SAM-BA 3.0 ARMv7 specific information

## Toolchain / Distribution

The selected toolchain is Yocto Poky distribution (release "dizzy"), with
additional meta-openembedded and meta-qt5 overlays.

This release was built with the prebuilt "Cortex-A5 Hard float with QT 5" Yocto
SDK from:
http://www.at91.com/linux4sam/bin/view/Linux4SAM/SoftwareTools#Yocto_Project_SDK

Information on how to rebuild the SDK is available here:
http://www.at91.com/linux4sam/bin/view/Linux4SAM/PokyBuild

## Package content

Most required libraries are included in the package (Qt5, libstdc++6).
Non-included required libraries include:
- libc6 (glibc 2.20)
- OpenSSL (1.0.0)
Your sysroot must contain versions of these libraries equivalent to those
provided by Yocto Poky "dizzy".

Note: It is possible to remove Qt5 and libstdc++ from the libs directory if
your sysroot already contains compatible versions of these libraries.
