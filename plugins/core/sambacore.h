#ifndef SAMBA_CORE_H
#define SAMBA_CORE_H

#include <QObject>
#include <QtQml>

class Q_DECL_EXPORT SambaCorePlugin : public QQmlExtensionPlugin
{
	Q_OBJECT
	Q_PLUGIN_METADATA(IID "org.qt-project.Qt.QQmlExtensionInterface")

public:
	void registerTypes(const char *uri);
};

#endif // SAMBA_CORE_H
