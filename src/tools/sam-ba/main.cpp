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
