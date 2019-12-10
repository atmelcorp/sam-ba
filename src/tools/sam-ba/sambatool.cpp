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

#include "sambatool.h"
#include "sambatoolcontext.h"
#include <QFile>
#include <iostream>

static void cerr_msg(const QString& str)
{
	std::cerr << str.toLocal8Bit().constData() << std::endl;
}

static QStringList callArrayJsFunction(QObject* obj, const QString& functionName)
{
	const char* func = QString("%1()").arg(functionName).toLocal8Bit();
	if (obj->metaObject()->indexOfMethod(func) == -1) {
		return QStringList();
	}
	func = functionName.toLocal8Bit();
	QVariant returnedValue;
	if (!QMetaObject::invokeMethod(obj, func,
	                               Q_RETURN_ARG(QVariant, returnedValue))) {
		return QStringList();
	}
	if (!returnedValue.canConvert(QVariant::StringList)) {
		return QStringList();
	}
	return returnedValue.toStringList();
}

static QStringList callArrayJsFunction(QObject* obj, const QString& functionName, const QString& arg)
{
	const char* func = QString("%1(QVariant)").arg(functionName).toLocal8Bit();
	if (obj->metaObject()->indexOfMethod(func) == -1) {
		return QStringList();
	}
	func = functionName.toLocal8Bit();
	QVariant returnedValue;
	if (!QMetaObject::invokeMethod(obj, func,
	                               Q_RETURN_ARG(QVariant, returnedValue),
	                               Q_ARG(QVariant, QVariant(arg)))) {
		return QStringList();
	}
	if (!returnedValue.canConvert(QVariant::StringList)) {
		return QStringList();
	}
	return returnedValue.toStringList();
}

static bool callBooleanJsFunction(QObject* obj, const QString& functionName, bool defaultValue = false)
{
	const char *func = QString("%1()").arg(functionName).toLocal8Bit();
	if (obj->metaObject()->indexOfMethod(func) == -1) {
		return defaultValue;
	}
	func = functionName.toLocal8Bit();
	QVariant returnedValue;
	if (!QMetaObject::invokeMethod(obj, func,
				       Q_RETURN_ARG(QVariant, returnedValue))) {
		return defaultValue;
	}
	if (!returnedValue.canConvert(QVariant::Bool)) {
		return defaultValue;
	}
	return returnedValue.toBool();
}

SambaTool::SambaTool(int& argc, char** argv)
    : QCoreApplication(argc, argv),
      m_engine(this),
      m_traceLevel(3),
      m_port(0),
      m_device(0),
      m_applet(0)
{
	setApplicationName("sam-ba");
	setApplicationVersion(SAMBA_VERSION);
	m_status = parseArguments(arguments());
}

SambaTool::~SambaTool()
{
}

void SambaTool::displayVersion()
{
	cerr_msg(QString("SAM-BA Command Line Tool v%1").arg(applicationVersion()));
	cerr_msg("Copyright 2018 Microchip Technology");
}

void SambaTool::displayPortHelp()
{
	QStringList ports;
	foreach(SambaComponent* port, m_engine.listComponents(COMPONENT_CONNECTION))
		ports << port->name();
	cerr_msg(QString("Known ports: %2").arg(ports.join(", ")));
}

void SambaTool::displayJsCommandLineHelp(QObject* obj)
{
	QStringList helpList = callArrayJsFunction(obj, "commandLineHelp");
	if (helpList.isEmpty()) {
		cerr_msg("No help available :(");
	}
	else {
		foreach (QString help, helpList)
			cerr_msg(help);
	}
}

void SambaTool::displayJsCommandLineCommandsHelp(QObject* obj)
{
	QStringList commands = callArrayJsFunction(obj, "commandLineCommands");
	if (commands.isEmpty()) {
		cerr_msg("No commands supported");
	}
	else {
		foreach(QString command, commands) {
			QStringList helpList = callArrayJsFunction(obj, "commandLineCommandHelp", command);
			if (helpList.isEmpty()) {
				cerr_msg(QString("* %1 - no help available :(").arg(command));
			}
			else {
				foreach (QString help, helpList)
					cerr_msg(help);
			}
			cerr_msg(QString());
		}
	}
}

bool SambaTool::parseObjectArguments(QObject* object, const QString& cmdline, const QStringList& args, const QString& what)
{
	if (args.length() > 0) {
		// only one "help" argument: display help
		if (args.length() == 1 && args[0] == "help") {
			displayJsCommandLineHelp(object);
			return false;
		}

		// javascript "commandLineParse" function not found: ignore arguments
		if (object->metaObject()->indexOfMethod("commandLineParse(QVariant)") == -1) {
			cerr_msg(QString("Warning: Arguments ignored for %1 '%2'")
			         .arg(what).arg(cmdline));
			return true;
		}

		// invoke javascript "commandLineParse" method
		QVariant returnedValue;
		if (!QMetaObject::invokeMethod(object, "commandLineParse",
		                               Q_RETURN_ARG(QVariant, returnedValue),
		                               Q_ARG(QVariant, QVariant(args)))) {
			cerr_msg(QString("Error: Could not configure %1 '%2': Could not invoke 'commandLineParse' method.").arg(what).arg(cmdline));
			return false;
		}

		// check if javascript function returned an error message
		if (returnedValue.type() == QVariant::String) {
			cerr_msg(QString("Error: Could not configure %1 '%2': %3")
			         .arg(what).arg(cmdline).arg(returnedValue.toString()));
			return false;
		}
	}
	return true;
}

bool SambaTool::parsePortOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	SambaComponent* comp = m_engine.findComponent(COMPONENT_CONNECTION, name);
	if (!comp) {
		cerr_msg(QString("Error: Unknown port '%1'.").arg(name));
		return false;
	}

	QObject* port = comp->newInstance();

	if (!parseObjectArguments(port, value, args, "port"))
		return false;

	m_port = port;
	return true;
}

void SambaTool::displayDeviceHelp()
{
	QStringList devices;
	foreach(SambaComponent* device, m_engine.listComponents(COMPONENT_DEVICE))
		devices << device->name();
	cerr_msg(QString("Known devices: %1").arg(devices.join(", ")));
}

bool SambaTool::parseDeviceOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	SambaComponent* comp = m_engine.findComponent(COMPONENT_DEVICE, name);
	if (!comp) {
		cerr_msg(QString("Error: Unknown device '%1'.").arg(name));
		return false;
	}

	QObject* device = comp->newInstance();

	if (!parseObjectArguments(device, value, args, "device"))
		return false;

	m_device = device;
	return true;
}

void SambaTool::displayBoardHelp()
{
	QStringList boards;
	foreach(SambaComponent* board, m_engine.listComponents(COMPONENT_BOARD))
		boards << board->name();
	cerr_msg(QString("Known boards: %1").arg(boards.join(", ")));
}

bool SambaTool::parseBoardOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	SambaComponent* comp = m_engine.findComponent(COMPONENT_BOARD, name);
	if (!comp) {
		cerr_msg(QString("Error: Unknown board '%1'.").arg(name));
		return false;
	}

	QObject* board = comp->newInstance();

	if (!parseObjectArguments(board, value, args, "board"))
		return false;

	m_device = board;
	return true;
}

void SambaTool::displayAppletHelp()
{
	if (!m_device) {
		cerr_msg(QString("Known applets: none (neither device nor board is set)"));
		return;
	}

	bool isSecured = callBooleanJsFunction(m_port, "toSecureMonitor");
	const char *functionName = isSecured ? "securedAppletNames" : "nonSecuredAppletNames";
	QStringList names = callArrayJsFunction(m_device, functionName);
	cerr_msg(QString("Known applets: %1").arg(names.join(", ")));
}

QObject* SambaTool::findApplet(const QString& name)
{
	if (!m_device) {
		cerr_msg(QString("Error: Could not find applet '%1': No device or board is set!")
		         .arg(name));
		return nullptr;
	}

	if (!m_port) {
		cerr_msg(QString("Error: Could not find applet '%1': No port is set!")
			 .arg(name));
		return nullptr;
	}

	m_port->setProperty("device", QVariant::fromValue<QObject*>(m_device));
	m_device->setProperty("connection", QVariant::fromValue<QObject*>(m_port));

	if (m_device->metaObject()->indexOfMethod("applet(QVariant)") == -1) {
		cerr_msg(QString("Error: Could not find applet '%1': Invalid number of arguments for 'applet' method.")
			 .arg(name));
		return nullptr;
	}
	QVariant returnedValue;
	if (!QMetaObject::invokeMethod(m_device, "applet",
	                               Q_RETURN_ARG(QVariant, returnedValue),
	                               Q_ARG(QVariant, QVariant(name)))) {
		cerr_msg(QString("Error: Could not find applet '%1': Could not invoke 'applet' method.")
			 .arg(name));
		return nullptr;
	}
	if (returnedValue.type() == QVariant::String) {
		cerr_msg(QString("Error: Could not find applet '%1': %2")
			 .arg(name).arg(returnedValue.toString()));
		return nullptr;
	}
	QObject* applet = qvariant_cast<QObject*>(returnedValue);
	if (!applet) {
		cerr_msg(QString("Error: Could not find applet '%1': unexpected value returned from 'applet' method.")
			 .arg(name).arg(returnedValue.toString()));
		return nullptr;
	}
	return applet;
}

bool SambaTool::parseAppletOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	QObject* applet = findApplet(name);
	if (!applet)
		return false;

	if (!parseObjectArguments(applet, value, args, "applet"))
		return false;

	m_applet = applet;
	return true;
}

void SambaTool::run()
{
	int returnCode = 0;

	if (m_status & Failed) {
		exit(-1);
		return;
	}

	if (m_port && m_device) {
		m_port->setProperty("device", QVariant::fromValue<QObject*>(m_device));
		m_device->setProperty("connection", QVariant::fromValue<QObject*>(m_port));
	}

	if (m_status & ShowPortHelp) {
		displayPortHelp();
		m_status |= Exit;
	}

	if (m_status & ShowDeviceHelp) {
		displayDeviceHelp();
		m_status |= Exit;
	}

	if (m_status & ShowBoardHelp) {
		displayBoardHelp();
		m_status |= Exit;
	}

	if (m_status & ShowAppletHelp) {
		displayAppletHelp();
		m_status |= Exit;
	}

	if (m_status & ShowMonitorCmdHelp) {
		displayJsCommandLineCommandsHelp(m_port);
		m_status |= Exit;
	}

	if (m_status & ShowAppletCmdHelp) {
		displayJsCommandLineCommandsHelp(m_applet);
		m_status |= Exit;
	}

	if (m_status & Exit) {
		exit(0);
		return;
	}

	// exit if no Run action and no Help displayed
	if ((m_status & (RunMonitor | RunApplet | RunUserScript)) == 0) {
		cerr_msg("Nothing to do? Hint: use --help");
		exit(0);
		return;
	}

	QQmlContext context(m_engine.qmlEngine());
	QObject* scriptProxy = m_engine.createComponentInstance("import SAMBA.Tool 3.2; ScriptProxy {}", &context);
	QObject* scriptContext = qvariant_cast<QObject*>(scriptProxy->property("script"));
	delete scriptProxy;

	scriptContext->setProperty("traceLevel", m_traceLevel);

	if ((m_status & (RunMonitor | RunApplet)) != 0)
	{
		SambaToolContext toolContext;
		if (m_port)
			toolContext.setPort(QVariant::fromValue<QObject*>(m_port));
		if (m_applet)
			toolContext.setAppletName(m_applet->property("name"));
		if (m_commands.isValid())
			toolContext.setCommands(m_commands);
		QObject::connect(&toolContext, SIGNAL(toolError(QString)),
		                 this, SLOT(onToolError(QString)));

		context.setContextProperty("Tool", &toolContext);

		QString script;
		if (m_status & RunMonitor) {
			script = "import SAMBA.Tool 3.2; MonitorCommandHandler {}";
		}
		else {
			script = "import SAMBA.Tool 3.2; AppletCommandHandler {}";
		}
		QObject* obj = m_engine.createComponentInstance(script, &context);
		if (obj)
			delete obj;
	}

	if (m_status & RunUserScript)
	{
		scriptContext->setProperty("arguments", QVariant::fromValue(m_userScriptArguments));
		/* change working dir if -w option is present */
		if (!m_workingDir.isEmpty())
			QDir::setCurrent(m_workingDir);

		QObject* obj = m_engine.createComponentInstance(m_userScript, &context);
		if (obj)
			delete obj;
	}

	returnCode = scriptContext->property("returnCode").toInt();

	exit((m_status & Failed) ? -1 : returnCode);
}

void SambaTool::onToolError(const QString& message)
{
	cerr_msg(message);
}

quint32 SambaTool::parseArguments(const QStringList& arguments)
{
	QCommandLineParser parser;

	QCommandLineOption versionOption(QStringList() << "v" << "version",
	                                 "Displays version information.");
	parser.addOption(versionOption);

	QCommandLineOption helpOption(QStringList() << "h" << "help",
	                                 "Displays this help.");
	parser.addOption(helpOption);

	QCommandLineOption traceLevelOption(QStringList() << "t" << "tracelevel",
	                                 "Set trace level to <trace_level>.",
	                                 "trace_level");
	parser.addOption(traceLevelOption);

	QCommandLineOption executeOption(QStringList() << "x" << "execute",
	                                 "Execute script <script.qml>.",
	                                 "script.qml");
	parser.addOption(executeOption);

	QCommandLineOption portOption(QStringList() << "p" << "port",
	                              "Communicate with device using <port>.",
	                              "port[:options:...]");
	parser.addOption(portOption);

	QCommandLineOption deviceOption(QStringList() << "d" << "device",
	                                "Connected device is <device>.",
	                                "device[:options:...]");
	parser.addOption(deviceOption);

	QCommandLineOption boardOption(QStringList() << "b" << "board",
	                               "Connected board is <board>.",
	                               "board[:options:...]");
	parser.addOption(boardOption);

	QCommandLineOption monitorOption(QStringList() << "m" << "monitor",
	                                 "Run monitor command <command>.",
	                                 "command[:options:...]");
	parser.addOption(monitorOption);

	QCommandLineOption appletOption(QStringList() << "a" << "applet",
	                                "Load and initialize applet <applet>.",
	                                "applet[:options:...]");
	parser.addOption(appletOption);

	QCommandLineOption commandOption(QStringList() << "c" << "command",
	                                 "Run command <command>.",
	                                 "command[:args:...]");
	parser.addOption(commandOption);

	QCommandLineOption workDirOption(QStringList() << "w" << "working-directory",
	                                 "Set working directory to <DIR>.",
	                                 "DIR");
	parser.addOption(workDirOption);

	// check if command line is empty
	if (arguments.length() < 2) {
		displayVersion();
		cerr_msg(QString());
		cerr_msg(parser.helpText());
		return Exit;
	}

	// parse command line arguments
	if (!parser.parse(arguments)) {
		cerr_msg(QString("Error: %1").arg(parser.errorText()));
		return Failed;
	}

	// check for version option
	if (parser.isSet(versionOption)) {
		displayVersion();
		return Exit;
	}

	// check for help option
	if (parser.isSet(helpOption)) {
		displayVersion();
		cerr_msg(QString());
		cerr_msg(parser.helpText());
		return Exit;
	}

	if (parser.isSet(traceLevelOption)) {
		m_traceLevel = parser.value(traceLevelOption).toUInt();
	}

	// check options cardinality
	if (parser.values(executeOption).length() > 1) {
		cerr_msg("Error: Only a single -x/--execute option can be present on the command line.");
		return Failed;
	}
	if (parser.values(portOption).length() > 1) {
		cerr_msg("Error: Only a single -p/--port option can be present on the command line.");
		return Failed;
	}
	if (parser.values(deviceOption).length() > 1) {
		cerr_msg("Error: Only a single -d/--device option can be present on the command line.");
		return Failed;
	}
	if (parser.values(boardOption).length() > 1) {
		cerr_msg("Error: Only a single -b/--board option can be present on the command line.");
		return Failed;
	}
	if (parser.values(appletOption).length() > 1) {
		cerr_msg("Error: Only a single -a/--applet option can be present on the command line.");
		return Failed;
	}
	if (parser.values(workDirOption).length() > 1) {
		cerr_msg("Error: Only a single -w/--working-directory option can be present on the command line.");
		return Failed;
	}

	// check options incompatibilities
	if (parser.isSet(executeOption)) {
		if (parser.isSet(portOption) || parser.isSet(deviceOption) ||
		    parser.isSet(boardOption) || parser.isSet(monitorOption) ||
		    parser.isSet(appletOption) || parser.isSet(commandOption)) {
			cerr_msg("Error: Option -x/--execute accepts only -w/--working-directory option.");
			return Failed;
		}
	}
	else if (parser.isSet(workDirOption)) {
		if (parser.isSet(portOption) || parser.isSet(deviceOption) ||
		    parser.isSet(boardOption) || parser.isSet(monitorOption) ||
		    parser.isSet(appletOption) || parser.isSet(commandOption) || !parser.isSet(executeOption)) {
			cerr_msg("Error: Option -w/--working-directory must be in conjuction with -x/--execute script option.");
			return Failed;
		}
	}
	else {
		// no positional arguments allowed
		if (!parser.positionalArguments().isEmpty()) {
			cerr_msg(QString("Error: Unknown arguments: %1")
					 .arg(parser.positionalArguments().join(' ')));
			return Failed;
		}
	}

	if (parser.isSet(deviceOption) && parser.isSet(boardOption)) {
		cerr_msg("Error: Options -d/--device and -b/--board are exclusive.");
		return Failed;
	}
	if (parser.isSet(monitorOption)) {
		if (parser.isSet(appletOption) || parser.isSet(commandOption)) {
			cerr_msg("Error: Cannot use -m/--monitor option with -a/--applet or -c/--command options.");
			return Failed;
		}
	}

	if (parser.isSet(executeOption)) {
		QFileInfo userScript(parser.value(executeOption));
		if (!userScript.exists()) {
			cerr_msg(QString("Error: User script '%1' not found.").arg(userScript.fileName()));
			return Failed;
		}
		m_userScript = QUrl::fromLocalFile(userScript.absoluteFilePath());
		m_userScriptArguments = parser.positionalArguments();

		if (parser.isSet(workDirOption)) {
			QDir workDir(parser.value(workDirOption));
			if (!workDir.exists()) {
				cerr_msg(QString("Error: Working directory '%1' not found.").arg(workDir.absolutePath()));
				return Failed;
			}
			m_workingDir = workDir.absolutePath() + QString("/");
		}

		return RunUserScript;
	}
	else {
		quint32 status = 0;

		// parse port
		if (parser.isSet(portOption)) {
			QString port = parser.value(portOption);
			if (port.compare("help", Qt::CaseInsensitive) == 0) {
				status |= ShowPortHelp;
			}
			else {
				if (!parsePortOption(port))
					return Failed;
			}
		} else {
			SambaComponent* port(m_engine.listComponents(COMPONENT_CONNECTION).first());
			cerr_msg(QString("No port option on command-line, using '%1'.").arg(port->name()));
			if (!parsePortOption(port->name()))
				return Failed;
		}

		// parse device
		if (parser.isSet(deviceOption)) {
			QString device = parser.value(deviceOption);
			if (device.compare("help", Qt::CaseInsensitive) == 0) {
				status |= ShowDeviceHelp;
			}
			else {
				if (!parseDeviceOption(device))
					return Failed;
			}
		}

		// parse board
		if (parser.isSet(boardOption)) {
			QString board = parser.value(boardOption);
			if (board.compare("help", Qt::CaseInsensitive) == 0) {
				status |= ShowBoardHelp;
			}
			else {
				if (!parseBoardOption(board))
					return Failed;
			}
		}

		// parse applet
		if (parser.isSet(appletOption)) {
			QString applet = parser.value(appletOption);
			if (applet.compare("help", Qt::CaseInsensitive) == 0) {
				status |= ShowAppletHelp;
			}
			else {
				if (!parseAppletOption(applet)) {
					return Failed;
				}
				else {
					status |= RunApplet;
				}
			}
		}

		// parse monitor commands
		if (parser.isSet(monitorOption)) {
			QVariantList commands;
			foreach (QString command, parser.values(monitorOption)) {
				if (command.compare("help", Qt::CaseInsensitive) == 0) {
					status |= ShowMonitorCmdHelp;
				}
				else {
					QStringList args = command.split(":");
					commands << QVariant(args);
				}
			}
			if (status & ShowMonitorCmdHelp) {
				status &= ~RunMonitor;
			}
			else {
				m_commands = commands;
				status |= RunMonitor;
			}
		}
		if (status & RunMonitor) {
			if (!m_port) {
				cerr_msg("Error: Cannot run monitor commands because no port is set.");
				status |= Failed;
			}
			if (!m_device) {
				cerr_msg("Error: Cannot run monitor commands because neither device nor board are set.");
				status |= Failed;
			}
		}
		if (status & ShowMonitorCmdHelp) {
			if (!m_port) {
				cerr_msg("Error: Cannot show monitor commands because no port is set.");
				status |= Failed;
			}
			if (!m_device) {
				cerr_msg("Error: Cannot show monitor commands because neither device nor board are set.");
				status |= Failed;
			}
		}

		// parse applet commands
		if (parser.isSet(commandOption)) {
			QVariantList commands;
			foreach (QString command, parser.values(commandOption)) {
				if (command.compare("help", Qt::CaseInsensitive) == 0) {
					status |= ShowAppletCmdHelp;
				}
				else {
					QStringList args = command.split(":");
					commands << QVariant(args);
				}
			}
			if (status & ShowAppletCmdHelp) {
				status &= ~RunApplet;
			}
			else {
				m_commands = commands;
				status |= RunApplet;
			}
		}
		if (status & RunApplet) {
			if (!m_port) {
				cerr_msg("Error: Cannot run applet commands because no port is set.");
				status |= Failed;
			}
			if (!m_device) {
				cerr_msg("Error: Cannot run applet commands because neither device nor board are set.");
				status |= Failed;
			}
			if (!m_applet) {
				cerr_msg("Error: Cannot run applet commands because no applet is set.");
				status |= Failed;
			}
		}
		if (status & ShowAppletCmdHelp) {
			if (!m_device) {
				cerr_msg("Error: Cannot show applet commands because neither device nor board are set.");
				status |= Failed;
			}
			if (!m_applet) {
				cerr_msg("Error: Cannot show applet commands because no applet is set.");
				status |= Failed;
			}
		}

		return status;
	}
}
