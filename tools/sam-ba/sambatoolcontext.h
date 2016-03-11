#ifndef SAMBA_TOOL_CONTEXT_H
#define SAMBA_TOOL_CONTEXT_H

#include "sambacommon.h"
#include "sambaapplet.h"
#include "sambadevice.h"
#include "sambaconnection.h"
#include "sambascriptcontext.h"
#include <QObject>

class SambaToolContext : public SambaScriptContext
{
	Q_OBJECT
	Q_PROPERTY(QVariant port READ port NOTIFY portChanged)
	Q_PROPERTY(QVariant device READ device NOTIFY deviceChanged)
	Q_PROPERTY(QVariant applet READ applet NOTIFY appletChanged)
	Q_PROPERTY(QVariant commands READ commands NOTIFY commandsChanged)

public:
	SambaToolContext(QObject* parent = 0)
	    : SambaScriptContext(parent),
	      m_commands(QVariantList())
	{
	}

	QVariant port() const {
		return m_port;
	}

	void setPort(QVariant port)
	{
		m_port = port;
		emit portChanged();
	}

	QVariant device() const {
		return m_device;
	}

	void setDevice(QVariant device)
	{
		m_device = device;
		emit deviceChanged();
	}

	QVariant applet() const {
		return m_applet;
	}

	void setApplet(QVariant applet)
	{
		m_applet = applet;
		emit appletChanged();
	}

	QVariant commands() const {
		return m_commands;
	}

	void setCommands(const QVariant& commands)
	{
		m_commands = commands;
		emit commandsChanged();
	}

	Q_INVOKABLE void error(const QString& message)
	{
		emit toolError(message);
	}

signals:
	void portChanged();
	void deviceChanged();
	void appletChanged();
	void commandsChanged();
	void toolError(const QString& message);

private:
	QVariant m_port;
	QVariant m_device;
	QVariant m_applet;
	QVariant m_commands;
};

#endif // SAMBA_TOOL_CONTEXT_H
