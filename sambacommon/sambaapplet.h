#ifndef SAMBA_APPLET_H
#define SAMBA_APPLET_H

#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SambaApplet : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
	Q_PROPERTY(AppletKind kind READ kind WRITE setKind NOTIFY kindChanged)
	Q_PROPERTY(QString codeUrl READ codeUrl WRITE setCodeUrl NOTIFY codeUrlChanged)
	Q_PROPERTY(quint32 codeAddr READ codeAddr WRITE setCodeAddr NOTIFY codeAddrChanged)
	Q_PROPERTY(quint32 mailboxAddr READ mailboxAddr WRITE setMailboxAddr NOTIFY mailboxAddrChanged)
	Q_PROPERTY(quint32 memorySize READ memorySize WRITE setMemorySize NOTIFY memorySizeChanged)
	Q_PROPERTY(quint32 bufferAddr READ bufferAddr WRITE setBufferAddr NOTIFY bufferAddrChanged)
	Q_PROPERTY(quint32 bufferSize READ bufferSize WRITE setBufferSize NOTIFY bufferSizeChanged)
	Q_PROPERTY(QVariant commands READ commands WRITE setCommands NOTIFY commandsChanged)
	Q_PROPERTY(QVariant initArgs READ initArgs WRITE setInitArgs NOTIFY initArgsChanged)
	Q_ENUMS(AppletKind)

public:
	enum AppletKind
	{
		KindLowLevel,
		KindExtRAM,
		KindNVM,
		KindOther,
	};

	explicit SambaApplet(QQuickItem *parent = 0);

	QString name() const;
	void setName(const QString& name);

	QString description() const;
	void setDescription(const QString& description);

	AppletKind kind() const;
	void setKind(AppletKind kind);

	QString codeUrl() const;
	void setCodeUrl(const QString& codeUrl);

	quint32 codeAddr() const;
	void setCodeAddr(quint32 codeAddr);

	quint32 mailboxAddr() const;
	void setMailboxAddr(quint32 mailboxAddr);

	quint32 memorySize() const;
	void setMemorySize(quint32 memorySize);

	quint32 bufferAddr() const;
	void setBufferAddr(quint32 bufferAddr);

	quint32 bufferSize() const;
	void setBufferSize(quint32 bufferSize);

	QVariant commands() const;
	void setCommands(const QVariant& commands);

	Q_INVOKABLE bool hasCommand(const QString& name);
	Q_INVOKABLE quint32 command(const QString& name);

	QVariant initArgs() const;
	void setInitArgs(const QVariant& initArgs);

signals:
	void nameChanged();
	void descriptionChanged();
	void kindChanged();
	void codeUrlChanged();
	void codeAddrChanged();
	void mailboxAddrChanged();
	void memorySizeChanged();
	void bufferAddrChanged();
	void bufferSizeChanged();
	void commandsChanged();
	void initArgsChanged();

private:
	QString m_name;
	QString m_description;
	AppletKind m_kind;
	QString m_codeUrl;
	quint32 m_codeAddr;
	quint32 m_mailboxAddr;
	quint32 m_memorySize;
	quint32 m_bufferAddr;
	quint32 m_bufferSize;
	QVariant m_commands;
	QVariant m_initArgs;
};

#endif // SAMBA_APPLET_H
