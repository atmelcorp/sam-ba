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
	Q_PROPERTY(QStringList boards READ boards WRITE setBoards NOTIFY boardsChanged)
	Q_PROPERTY(QVariant board READ board WRITE setBoard NOTIFY boardChanged)
	Q_PROPERTY(QQmlListProperty<SambaApplet> applets READ applets)

public:
	explicit SambaDevice(QQuickItem *parent = 0);

	QString name() const;
	void setName(const QString& name);

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
	void boardsChanged();
	void boardChanged();

private:
	QString m_name;
	QStringList m_boards;
	QVariant m_board;
	QList<SambaApplet*> m_applets;
};

#endif // SAMBA_DEVICE_H
