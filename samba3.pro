TEMPLATE = subdirs

SUBDIRS = \
    sambacore \
    devices \
    sambacmd \
    sambaconnectionserial \
    sambaconnectionjlink

sambacmd.depends = sambacore
samba.depends = sambacore
sambaconnectionserial.depends = sambacore
sambaconnectionjlink.depends = sambacore
