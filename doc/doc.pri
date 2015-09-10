qtPrepareTool(QDOC, qdoc)
QDOC += -outputdir $$OUT_PWD/doc/html

OTHER_FILES += \
    $$PWD/samba3.qdocconf \
    $$PWD/index.qdoc

docs_html.target = docs
docs_html.commands = $$QDOC $$PWD/samba3.qdocconf

QMAKE_EXTRA_TARGETS = docs_html
QMAKE_CLEAN += "-r $$OUT_PWD/doc/html"

docs.path = /doc
docs.files = $$OUT_PWD/doc/html
INSTALL += docs
