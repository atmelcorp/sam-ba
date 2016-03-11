#include "sambatool.h"

#include <QCoreApplication>

int main(int argc, char *argv[])
{
	QLoggingCategory::setFilterRules("*.debug=false\n"
			"qml.debug=true");
	qSetMessagePattern("%{message}");

	SambaTool app(argc, argv);
	QTimer::singleShot(0, &app, &SambaTool::run);
	return app.exec();
}
