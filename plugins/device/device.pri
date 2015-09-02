for(devfile, DEVICE_FILES) {
    path = $${dirname(devfile)}
    eval(dev_$${path}.files += $$devfile)
    eval(dev_$${path}.path = /devices/$$path)
    eval(INSTALLS *= dev_$${path})
}
