for(devfile, DEVICE_FILES) {
    path = $${dirname(devfile)}
    eval(dev_$${path}.files += $$devfile)
    eval(dev_$${path}.path = /qml/SAMBA/Device/$${DEVICE}/$$path)
    eval(INSTALLS *= dev_$${path})
}
