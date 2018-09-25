TEMPLATE = subdirs

SUBDIRS = xmodem serial

exists($${JLINKSDKPATH}/Inc/JLinkARMDLL.h):SUBDIRS += jlink
