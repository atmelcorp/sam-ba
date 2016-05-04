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

#ifndef SAMBA_DEVICE_H
#define SAMBA_DEVICE_H

#include <sambacommon.h>
#include <sambaapplet.h>
#include <QObject>
#include <QtQml>
#include <QtQuick/QQuickItem>

class SAMBACOMMONSHARED_EXPORT SambaDevice : public QQuickItem
{
	Q_OBJECT
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QStringList aliases READ aliases WRITE setAliases NOTIFY aliasesChanged)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
	Q_PROPERTY(QStringList boards READ boards WRITE setBoards NOTIFY boardsChanged)
	Q_PROPERTY(QVariant board READ board WRITE setBoard NOTIFY boardChanged)
	Q_PROPERTY(QQmlListProperty<SambaApplet> applets READ applets)

public:
	explicit SambaDevice(QQuickItem *parent = 0);

	QString name() const;
	void setName(const QString& name);

	QStringList aliases() const;
	void setAliases(const QStringList& aliases);

	QString description() const;
	void setDescription(const QString& description);

	QStringList boards() const;
	void setBoards(const QStringList& boards);

	QVariant board() const;
	void setBoard(const QVariant& board);

	QQmlListProperty<SambaApplet> applets();
	int appletCount() const;
	SambaApplet *applet(int index) const;

	Q_INVOKABLE SambaApplet* applet(const QString& name) const;

signals:
	void nameChanged();
	void aliasesChanged();
	void descriptionChanged();
	void boardsChanged();
	void boardChanged();

private:
	QString m_name;
	QStringList m_aliases;
	QString m_description;
	QStringList m_boards;
	QVariant m_board;
	QList<SambaApplet*> m_applets;
};

#endif // SAMBA_DEVICE_H
