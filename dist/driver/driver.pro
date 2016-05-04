TEMPLATE = aux

driver.path = /driver
driver.files += \
    $$PWD/atm6124_cdc.cat \
    $$PWD/atm6124_cdc.inf

INSTALLS += driver
