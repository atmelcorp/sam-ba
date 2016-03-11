#ifndef SAMBA_TOOL_H
#define SAMBA_TOOL_H

#include "sambacommon.h"
#include "sambaengine.h"
#include "sambaapplet.h"
#include "sambaconnection.h"
#include "sambadevice.h"
#include "sambatoolcontext.h"
#include <QObject>
#include <QUrl>
#include <QtQml>

class Metadata;

class SambaTool : public QCoreApplication
{
	Q_OBJECT

public:
	enum ToolStatus
	{
		Failed             = (1 << 0),
		Exit               = (1 << 1),

		RunMonitor         = (1 << 2),
		RunApplet          = (1 << 3),
		RunUserScript      = (1 << 4),

		ShowPortHelp       = (1 << 5),
		ShowDeviceHelp     = (1 << 6),
		ShowBoardHelp      = (1 << 7),
		ShowAppletHelp     = (1 << 8),
		ShowMonitorCmdHelp = (1 << 9),
		ShowAppletCmdHelp  = (1 << 10),
	};

	explicit SambaTool(int &argc, char **argv);
	~SambaTool();

	void run();

private:
	bool loadAllMetadata();
	bool loadMetadata(QString fileName);

	quint32 parseArguments(const QStringList& arguments);

	void displayPortHelp();
	bool parsePortOption(const QString& value);

	void displayBoardHelp();
	bool parseBoardOption(const QString& value);

	void displayDeviceHelp();
	bool parseDeviceOption(const QString& value);

	void displayAppletHelp();
	bool parseAppletOption(const QString& value);

	void displayMonitorCommandHelp();
	void displayAppletCommandHelp();

	QStringList callArrayJsFunction(QObject* obj, const QString& functionName);
	QStringList callArrayJsFunction(QObject* obj, const QString& functionName, const QString& arg);
	void displayJsCommandLineHelp(QObject* obj);
	void displayJsCommandLineCommandsHelp(QObject* obj);

private slots:
	void onToolError(const QString& message);

private:
	SambaEngine m_engine;
	QList<SambaConnection*> m_ports;
	QList<SambaDevice*> m_devices;

	quint32 m_status;

	QUrl m_userScript;
	QStringList m_userScriptArguments;

	SambaConnection* m_port;
	SambaDevice* m_device;
	SambaApplet* m_applet;
	QVariant m_commands;
};

#endif // SAMBA_TOOL_H
