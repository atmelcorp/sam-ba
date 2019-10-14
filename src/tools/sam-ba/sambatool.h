/*
 * Copyright (c) 2015-2016, Atmel Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

#ifndef SAMBA_TOOL_H
#define SAMBA_TOOL_H

#include "sambaengine.h"
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
	quint32 parseArguments(const QStringList& arguments);

	void displayVersion();

	void displayPortHelp();
	bool parsePortOption(const QString& value);

	void displayBoardHelp();
	bool parseBoardOption(const QString& value);

	void displayDeviceHelp();
	bool parseDeviceOption(const QString& value);

	void displayAppletHelp();
	QObject* findApplet(const QString& name);
	bool parseAppletOption(const QString& value);

	void displayMonitorCommandHelp();
	void displayAppletCommandHelp();

	void displayJsCommandLineHelp(QObject* obj);
	void displayJsCommandLineCommandsHelp(QObject* obj);
	QObject* findObject(const QList<QObject*>& objects, const QString& name);
	bool parseObjectArguments(QObject* object, const QString& cmdline, const QStringList& args, const QString& what);

private slots:
	void onToolError(const QString& message);

private:
	SambaEngine m_engine;

	quint32 m_status;

	quint32 m_traceLevel;

	QUrl m_userScript;
	QStringList m_userScriptArguments;
	QString m_workingDir;

	QObject* m_port;
	QObject* m_device;
	QObject* m_applet;
	QVariant m_commands;
};

#endif // SAMBA_TOOL_H
