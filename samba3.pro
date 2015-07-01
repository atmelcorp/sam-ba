TEMPLATE = subdirs

DISTFILES += TODO README.md LICENSE.txt

SUBDIRS = \
    sambacore \
    devices \
    sambacmd \
    sambaconnectionserial \
    sambaconnectionjlink

sambacmd.depends = sambacore
sambaconnectionserial.depends = sambacore
sambaconnectionjlink.depends = sambacore
