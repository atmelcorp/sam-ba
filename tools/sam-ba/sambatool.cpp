#include "sambatool.h"
#include "sambascriptcontext.h"
#include <QFile>
#include <iostream>

static void cerr_msg(const QString& str)
{
	std::cerr << str.toLocal8Bit().constData() << std::endl;
}

static QObject* parseJson(SambaEngine& engine, const QJsonObject& obj)
{
	// parse JSON
	QString module = obj["module"].toString();
	QString module_version = obj["module_version"].toString();
	QString classname = obj["classname"].toString();

	// create object instance
	QString script = QString("import %1 %2; %3 { }")
			.arg(module).arg(module_version).arg(classname);
	QQmlComponent component(engine.qmlEngine());
	component.setData(script.toLocal8Bit(), QUrl());
	if (component.status() != QQmlComponent::Ready) {
		cerr_msg(script);
		cerr_msg(component.errorString());
		return 0;
	}
	return engine.createComponentInstance(&component, 0);
}

SambaTool::SambaTool(int& argc, char** argv)
    : QCoreApplication(argc, argv),
      m_engine(this),
      m_port(0),
      m_device(0),
      m_applet(0)
{
	setApplicationName("sam-ba");
	setApplicationVersion("3.1");

	loadAllMetadata();
	m_status = parseArguments(arguments());
}

SambaTool::~SambaTool()
{
	qDeleteAll(m_ports);
	m_ports.clear();

	qDeleteAll(m_devices);
	m_devices.clear();
}

bool SambaTool::loadAllMetadata()
{
	QDir metadataDir(applicationDirPath() + "/metadata");
	foreach (QString fileName, metadataDir.entryList(QStringList() << "*.json",
	                                                 QDir::Files))
	{
		loadMetadata(metadataDir.absoluteFilePath(fileName));
	}
	return true;
}

bool SambaTool::loadMetadata(QString fileName)
{
	QFile file(fileName);

	if (!file.open(QIODevice::ReadOnly)) {
		cerr_msg(QString("Couldn't open metadata file '%1'.").arg(fileName));
		return false;
	}

	QByteArray data = file.readAll();
	QJsonDocument doc(QJsonDocument::fromJson(data));
	QObject* obj = parseJson(m_engine, doc.object());
	if (!obj) {
		cerr_msg(QString("Couldn't parse metadata file '%1'.").arg(fileName));
		return false;
	}

	SambaConnection* port = qobject_cast<SambaConnection*>(obj);
	if (port) {
		m_ports << port;
		return true;
	}

	SambaDevice* device = qobject_cast<SambaDevice*>(obj);
	if (device) {
		m_devices << device;
		return true;
	}

	cerr_msg(QString("Ignoring metadata file '%1': unknown metadata type.")
	         .arg(fileName));
	delete obj;
	return false;
}

void SambaTool::displayPortHelp()
{
	QString values;
	foreach(SambaConnection* port, m_ports)
	{
		if (values.size() > 0)
			values += ", ";
		values += port->name();
	}
	cerr_msg(QString("Known ports: %2").arg(values));
}

QStringList SambaTool::callArrayJsFunction(QObject* obj, const QString& functionName)
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

QStringList SambaTool::callArrayJsFunction(QObject* obj, const QString& functionName, const QString& arg)
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
		}
	}
}

bool SambaTool::parsePortOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	SambaConnection* port = 0;
	foreach (SambaConnection* p, m_ports) {
		if (!p->name().compare(name, Qt::CaseInsensitive) ||
		    p->aliases().contains(name, Qt::CaseInsensitive)) {
			port = p;
			break;
		}
	}
	if (!port) {
		cerr_msg(QString("Error: Unknown port '%1'.").arg(value));
		return false;
	}

	if (args.length() > 0) {
		if (args.length() == 1 && args[0] == "help") {
			displayJsCommandLineHelp(port);
			return false;
		}
		if (port->metaObject()->indexOfMethod("commandLineParse(QVariant)") == -1) {
			cerr_msg(QString("Error: Could not create port '%1': Invalid number of arguments.")
			         .arg(value));
			delete port;
			return false;
		}
		QVariant returnedValue;
		if (!QMetaObject::invokeMethod(port, "commandLineParse",
		                               Q_RETURN_ARG(QVariant, returnedValue),
		                               Q_ARG(QVariant, QVariant(args)))) {
			cerr_msg(QString("Error: Could not create port '%1': Could not invoke parse method.")
			         .arg(value));
			delete port;
			return false;
		}
		if (returnedValue.type() == QVariant::String) {
			cerr_msg(QString("Error: Could not create port '%1': %2")
			         .arg(value).arg(returnedValue.toString()));
			delete port;
			return false;
		}
	}

	m_port = port;
	return true;
}

void SambaTool::displayDeviceHelp()
{
	QStringList devices;
	foreach(SambaDevice* device, m_devices)
		devices << device->name();
	cerr_msg(QString("Known devices: %1").arg(devices.join(", ")));
}

bool SambaTool::parseDeviceOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	if (args.length() > 0)
		cerr_msg("Warning: Devices have no arguments.");

	SambaDevice* device = 0;
	foreach (SambaDevice* d, m_devices) {
		if (!d->name().compare(name, Qt::CaseInsensitive) ||
		    d->aliases().contains(name, Qt::CaseInsensitive)) {
			device = d;
			break;
		}
	}
	if (!device) {
		cerr_msg(QString("Error: Unknown device '%1'.").arg(name));
		displayDeviceHelp();
		return false;
	}

	m_device = device;
	return true;
}

void SambaTool::displayBoardHelp()
{
	QStringList boards;
	foreach(SambaDevice* device, m_devices)
		foreach(QString board, device->boards())
			boards << board;
	cerr_msg(QString("Known boards: %1").arg(boards.join(", ")));
}

bool SambaTool::parseBoardOption(const QString& value)
{
	QStringList args = value.split(":");
	QString name = args.first();
	args.removeFirst();

	if (args.length() > 0)
		cerr_msg("Warning: Boards have no arguments.");

	SambaDevice* device = 0;
	foreach (SambaDevice* d, m_devices) {
		if (d->boards().contains(name)) {
			device = d;
			break;
		}
	}
	if (!device) {
		cerr_msg(QString("Error: Unknown board '%1'.").arg(name));
		displayBoardHelp();
		return false;
	}

	device->setBoard(QVariant(name));
	if (device->board().toString() != name)
	{
		cerr_msg(QString("Error: Could not create board '%1'.").arg(name));
		delete device;
		return false;
	}

	m_device = device;
	return true;
}

void SambaTool::displayAppletHelp()
{
	if (!m_device) {
		cerr_msg(QString("Known applets: none (neither device nor board is set)"));
		return;
	}

	QStringList applets;
	for (int i = 0; i < m_device->appletCount(); i++) {
		SambaApplet *applet = m_device->applet(i);
		applets << applet->name();
	}
	cerr_msg(QString("Known applets: %1").arg(applets.join(", ")));}

bool SambaTool::parseAppletOption(const QString& value)
{
	if (!m_device) {
		cerr_msg(QString("Error: Unknown applet '%1': No device or board is set!")
		         .arg(value));
		return false;
	}

	QStringList args = value.split(":");
	QString appletName = args.first();
	args.removeFirst();

	SambaApplet *applet = m_device->applet(appletName);
	if (!applet) {
		cerr_msg(QString("Error: Unknown applet '%1'.").arg(value));
		displayAppletHelp();
		return false;
	}

	if (args.length() > 0) {
		if (args.length() == 1 && args[0] == "help") {
			displayJsCommandLineHelp(applet);
			return false;
		}
		if (applet->metaObject()->indexOfMethod("commandLineParse(QVariant,QVariant)") == -1) {
			cerr_msg(QString("Error: Could not create applet '%1': Invalid number of arguments.")
			         .arg(value));
			return false;
		}
		QVariant returnedValue;
		if (!QMetaObject::invokeMethod(applet, "commandLineParse",
		                               Q_RETURN_ARG(QVariant, returnedValue),
		                               Q_ARG(QVariant, QVariant::fromValue<QObject*>(m_device)),
		                               Q_ARG(QVariant, QVariant(args)))) {
			cerr_msg(QString("Error: Could not create applet '%1': Could not invoke parseArguments method.")
			         .arg(value));
			return false;
		}
		if (returnedValue.type() == QVariant::String) {
			cerr_msg(QString("Error: Could not create applet '%1': %2")
			         .arg(value).arg(returnedValue.toString()));
			return false;
		}
	}

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

	if ((m_status & (RunMonitor | RunApplet)) != 0)
	{
		SambaToolContext toolContext;
		if (m_port)
			toolContext.setPort(QVariant::fromValue<QObject*>(m_port));
		if (m_device)
			toolContext.setDevice(QVariant::fromValue<QObject*>(m_device));
		if (m_applet)
			toolContext.setApplet(QVariant::fromValue<QObject*>(m_applet));
		if (m_commands.isValid())
			toolContext.setCommands(m_commands);

		QObject::connect(&toolContext, SIGNAL(toolError(QString)),
						 this, SLOT(onToolError(QString)));

		QQmlContext context(m_engine.qmlEngine());
		context.setContextProperty("Tool", &toolContext);

		QString script;
		if (m_status & RunMonitor) {
			script = "import SAMBA.Tool 3.1; MonitorCommandHandler {}";
		}
		else {
			script = "import SAMBA.Tool 3.1; AppletCommandHandler {}";
		}
		QObject* obj = m_engine.createComponentInstance(script, &context);
		if (obj) {
			returnCode = toolContext.returnCode();
			delete obj;
		}
	}

	if (m_status & RunUserScript)
	{
		SambaScriptContext scriptContext;
		scriptContext.setArguments(m_userScriptArguments);

		QQmlContext context(m_engine.qmlEngine());
		context.setContextProperty("Script", &scriptContext);

		QObject* obj = m_engine.createComponentInstance(m_userScript, &context);
		if (obj) {
			returnCode = scriptContext.returnCode();
			delete obj;
		}
	}

	exit((m_status & Failed) ? -1 : returnCode);
}

void SambaTool::onToolError(const QString& message)
{
	cerr_msg(message);
}

quint32 SambaTool::parseArguments(const QStringList& arguments)
{
	QCommandLineParser parser;
	parser.setApplicationDescription("SAM-BA Command Line Tool");
	parser.addVersionOption();

	QCommandLineOption helpOption = parser.addHelpOption();

	QCommandLineOption executeOption(QStringList() << "x" << "execute",
	                                 "Execute script <script-file>.",
	                                 "script.qml");
	parser.addOption(executeOption);

	QCommandLineOption portOption(QStringList() << "p" << "port",
	                              "Communicate with device using <port>.",
	                              "port[:options:...]");
	parser.addOption(portOption);

	QCommandLineOption deviceOption(QStringList() << "d" << "device",
	                                "Connected device is <device>.",
	                                "device");
	parser.addOption(deviceOption);

	QCommandLineOption boardOption(QStringList() << "b" << "board",
	                               "Connected board is <board>.",
	                               "board");
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

	// check if command line is empty
	if (arguments.length() < 2) {
		cerr_msg(parser.helpText());
		return Exit;
	}

	// parse command line arguments
	if (!parser.parse(arguments)) {
		cerr_msg(QString("Error: %1").arg(parser.errorText()));
		return Failed;
	}

	// ignore positional arguments
	if (!parser.positionalArguments().isEmpty()) {
		cerr_msg(QString("Error: Unknown arguments: %1")
		         .arg(parser.positionalArguments().join(' ')));
		return Failed;
	}

	// check for help option
	if (parser.isSet(helpOption)) {
		cerr_msg(parser.helpText());
		return Exit;
	}

	// check options cardinality
	if (parser.values(executeOption).length() > 1) {
		cerr_msg("Error: Only a single -p/--port option can be present on the command line.");
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

	// check options incompatibilities
	if (parser.isSet(executeOption)) {
		if (parser.isSet(portOption) || parser.isSet(deviceOption) ||
		    parser.isSet(boardOption) || parser.isSet(monitorOption) ||
		    parser.isSet(appletOption) || parser.isSet(commandOption)) {
			cerr_msg("Error: Option -x/--execute must be the only option on the command line.");
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
		if (parser.isSet(deviceOption))
			cerr_msg("Warning: Option -d/--device is ignored when executing monitor commands.");
		if (parser.isSet(boardOption))
			cerr_msg("Warning: Option -b/--board is ignored when executing monitor commands.");
	}

	if (parser.isSet(executeOption)) {
		QFile userScript(parser.value(executeOption));
		if (!userScript.exists()) {
			cerr_msg(QString("Error: User script '%1' not found.").arg(userScript.fileName()));
			return Failed;
		}
		m_userScript = QUrl::fromLocalFile(userScript.fileName());
		m_userScriptArguments = parser.positionalArguments();
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
		}
		if (status & ShowMonitorCmdHelp) {
			if (!m_port) {
				cerr_msg("Error: Cannot show monitor commands because no port is set.");
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
			if (!m_applet) {
				cerr_msg("Error: Cannot run applet commands because no applet is set.");
				status |= Failed;
			}
		}
		if (status & ShowAppletCmdHelp) {
			if (!m_applet) {
				cerr_msg("Error: Cannot show applet commands because no applet is set.");
				status |= Failed;
			}
		}

		return status;
	}
}
