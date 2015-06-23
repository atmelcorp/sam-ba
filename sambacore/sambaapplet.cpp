#include "sambaapplet.h"

SambaApplet::SambaApplet(QObject *parent)
	: SambaObject(parent),
	  m_loaded(false),
	  m_initialized(false),
	  m_memorySize(0),
	  m_bufferAddress(0),
	  m_bufferSize(0)
{

}

SambaApplet::~SambaApplet()
{

}

bool SambaApplet::enabled() const
{
	return m_enabled;
}

void SambaApplet::setEnabled(bool enabled)
{
	m_enabled = enabled;
	emit enabledChanged();
}

SambaApplet::AppletKind SambaApplet::kind() const
{
	return m_kind;
}

void SambaApplet::setKind(SambaApplet::AppletKind kind)
{
	m_kind = kind;
	emit kindChanged();
}

QString SambaApplet::fileName() const
{
	return m_fileName;
}

void SambaApplet::setFileName(QString fileName)
{
	m_fileName = fileName;
	emit fileNameChanged();
}

quint32 SambaApplet::appletAddress() const
{
	return m_appletAddress;
}

void SambaApplet::setAppletAddress(int appletAddress)
{
	m_appletAddress = appletAddress;
	emit appletAddressChanged();
}

quint32 SambaApplet::mailboxAddress() const
{
	return m_mailboxAddress;
}

void SambaApplet::setMailboxAddress(int mailboxAddress)
{
	m_mailboxAddress = mailboxAddress;
	emit mailboxAddressChanged();
}

QObject *SambaApplet::configData() const
{
	return m_configData;
}

void SambaApplet::setConfigData(QObject *configData)
{
	m_configData = configData;
	emit configDataChanged();
}

QQmlComponent *SambaApplet::configComponent() const
{
	return m_configComponent;
}

void SambaApplet::setConfigComponent(QQmlComponent *configComponent)
{
	m_configComponent = configComponent;
	emit configComponentChanged();
}

bool SambaApplet::loaded() const
{
	return m_loaded;
}

void SambaApplet::setLoaded(bool loaded)
{
	m_loaded = loaded;
	emit loadedChanged();
}

bool SambaApplet::initialized() const
{
	return m_initialized;
}

quint32 SambaApplet::memorySize() const
{
	return m_memorySize;
}

quint32 SambaApplet::bufferAddress() const
{
	return m_bufferAddress;
}

quint32 SambaApplet::bufferSize() const
{
	return m_bufferSize;
}

void SambaApplet::setInitialized(quint32 memorySize, quint32 bufferAddress, quint32 bufferSize)
{
	m_initialized = true;
	m_memorySize = memorySize;
	m_bufferAddress = bufferAddress;
	m_bufferSize = bufferSize;
	emit initializedChanged();
}
