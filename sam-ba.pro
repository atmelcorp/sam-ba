TEMPLATE = subdirs

SUBDIRS = src examples dist doc

no_doc:SUBDIRS -= doc
