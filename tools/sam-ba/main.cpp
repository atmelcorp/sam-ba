#include "sambaengine.h"

#include <QCoreApplication>
#include <QTimer>
#include <QUrl>
#include <stdio.h>
#include <stdlib.h>

Q_LOGGING_CATEGORY(sambaLogTool, "samba.tool")

int main(int argc, char *argv[])
{
	QLoggingCategory::setFilterRules("*.debug=false\n"
			"qml.debug=true");
	qSetMessagePattern("%{message}");

	QCoreApplication app(argc, argv);
	QCoreApplication::setApplicationName("sam-ba");
	QCoreApplication::setApplicationVersion("3.0-pre4");

	QCommandLineParser parser;
	parser.setApplicationDescription("SAM-BA Command Line Tool");
	parser.addHelpOption();
	parser.addVersionOption();
	QCommandLineOption scriptOption("x",
			QCoreApplication::translate("main", "Execute script <script-file>."),
			QCoreApplication::translate("main", "script-file"));
	parser.addOption(scriptOption);
	parser.process(app);

	QString script = parser.value(scriptOption);
	if (script.isEmpty())
	{
		fprintf(stderr, parser.helpText().toLocal8Bit().constData());
		return -1;
	}

	SambaEngine engine(&app);

	qCDebug(sambaLogTool, "Loading script from %s", script.toLocal8Bit().constData());
	engine.evaluateScript(QUrl::fromLocalFile(script));

	//return app.exec();
}
