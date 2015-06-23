#ifndef SAMBA_APPLET_H
#define SAMBA_APPLET_H

#include "sambacore_global.h"
#include "sambaobject.h"
#include <QObject>
#include <QtQml>

class SAMBACORESHARED_EXPORT SambaApplet : public SambaObject
{
	Q_OBJECT

	Q_ENUMS(AppletKind)
	Q_ENUMS(AppletCommand)
	Q_ENUMS(AppletStatus)

	Q_PROPERTY(bool enabled READ enabled WRITE setEnabled NOTIFY enabledChanged)
	Q_PROPERTY(AppletKind kind READ kind WRITE setKind NOTIFY kindChanged)
	Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
	Q_PROPERTY(quint32 appletAddress READ appletAddress WRITE setAppletAddress NOTIFY appletAddressChanged)
	Q_PROPERTY(quint32 mailboxAddress READ mailboxAddress WRITE setMailboxAddress NOTIFY mailboxAddressChanged)
	Q_PROPERTY(QObject *configData READ configData WRITE setConfigData NOTIFY configDataChanged)
	Q_PROPERTY(QQmlComponent *configComponent READ configComponent WRITE setConfigComponent NOTIFY configComponentChanged)

	Q_PROPERTY(bool loaded READ loaded NOTIFY loadedChanged)
	Q_PROPERTY(bool initialized READ initialized NOTIFY initializedChanged)
	Q_PROPERTY(quint32 memorySize READ memorySize NOTIFY initializedChanged)
	Q_PROPERTY(quint32 bufferAddress READ bufferAddress NOTIFY initializedChanged)
	Q_PROPERTY(quint32 bufferSize READ bufferSize NOTIFY initializedChanged)

public:
	explicit SambaApplet(QObject *parent = 0);
	~SambaApplet();

	enum AppletKind {
		Lowlevel,
		Extram,
		NVM,
		Other
	};

	enum AppletCommand {
		CmdInit      = 0x00000000,
		CmdWrite     = 0x00000002,
		CmdRead      = 0x00000003
	};

	enum AppletStatus {
		StatusSuccess       = 0x00000000,
		StatusUnknownDevice = 0x00000001,
		StatusWriteFail     = 0x00000002,
		StatusReadFail      = 0x00000003,
		StatusProtectFail   = 0x00000004,
		StatusUnprotectFail = 0x00000005,
		StatusEraseFail     = 0x00000006,
		StatusNoDevice      = 0x00000007,
		StatusAlignError    = 0x00000008,
		StatusBadBlock      = 0x00000009,
		StatusPMECCConfig   = 0x0000000a,
		StatusGenericFail   = 0x0000000f
	};

	enum AppletCommType {
		CommUSB    = 0x00000000,
		CommSerial = 0x00000001,
		CommJTAG   = 0x00000002
	};

	bool enabled() const;
	void setEnabled(bool enabled);

	AppletKind kind() const;
	void setKind(AppletKind kind);

	QString fileName() const;
	void setFileName(QString fileName);

	quint32 appletAddress() const;
	void setAppletAddress(int appletAddress);

	quint32 mailboxAddress() const;
	void setMailboxAddress(int mailboxAddress);

	QObject *configData() const;
	void setConfigData(QObject *configData);

	QQmlComponent *configComponent() const;
	void setConfigComponent(QQmlComponent *configComponent);

	bool loaded() const;
	void setLoaded(bool loaded);

	bool initialized() const;
	quint32 memorySize() const;
	quint32 bufferAddress() const;
	quint32 bufferSize() const;
	void setInitialized(quint32 memorySize, quint32 bufferAddress, quint32 bufferSize);

signals:
	void enabledChanged();
	void kindChanged();
	void fileNameChanged();
	void appletAddressChanged();
	void mailboxAddressChanged();
	void configDataChanged();
	void configComponentChanged();
	void loadedChanged();
	void initializedChanged();

private:
	bool m_enabled;
	AppletKind m_kind;
	QString m_tag;
	QString m_name;
	QString m_description;
	QString m_fileName;
	quint32 m_appletAddress;
	quint32 m_mailboxAddress;
	QObject *m_configData;
	QQmlComponent *m_configComponent;
	bool m_loaded;
	bool m_initialized;
	quint32 m_memorySize;
	quint32 m_bufferAddress;
	quint32 m_bufferSize;
};

#endif // SAMBA_APPLET_H
