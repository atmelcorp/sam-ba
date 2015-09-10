TEMPLATE = aux

qtPrepareTool(QDOC, qdoc)
QDOC += -outputdir \$(INSTALL_ROOT)/doc

docs.path = /doc
docs.commands = $$QDOC $$PWD/samba3.qdocconf
INSTALLS += docs

OTHER_FILES += \
    $$PWD/samba3.qdocconf \
    $$PWD/index.qdoc

