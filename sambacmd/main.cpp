#include "sambacore.h"

#include <QCoreApplication>
#include <QDebug>
#include <QTimer>
#include <QUrl>

int main(int argc, char *argv[])
{
	QCoreApplication app(argc, argv);

	QCoreApplication::setApplicationName("sambacmd");
	QCoreApplication::setApplicationVersion("3.0-pre3");

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
		qDebug().noquote() << parser.helpText();
		return -1;
	}

	SambaCore core(&app);

	qDebug("Loading script from %s", script.toLatin1().constData());
	QVariant result = core.evaluateScript(QUrl::fromLocalFile(script));
	if (result.isValid())
		qDebug().noquote() << result.toString();

	//return app.exec();
}
