#include "sambadevice.h"

SambaDevice::SambaDevice(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name(""),
	  m_description("")
{
}

QString SambaDevice::name() const
{
	return m_name;
}

void SambaDevice::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QStringList SambaDevice::aliases() const
{
	return m_aliases;
}

void SambaDevice::setAliases(const QStringList& aliases)
{
	m_aliases = aliases;
	emit aliasesChanged();
}

QString SambaDevice::description() const
{
	return m_description;
}

void SambaDevice::setDescription(const QString& description)
{
	m_description = description;
	emit descriptionChanged();
}

QStringList SambaDevice::boards() const
{
	return m_boards;
}

void SambaDevice::setBoards(const QStringList& boards)
{
	m_boards = boards;
	emit boardsChanged();
}

QVariant SambaDevice::board() const
{
	return QVariant(m_board);
}

void SambaDevice::setBoard(const QVariant& board)
{
	m_board = board;
	emit boardChanged();
}

QQmlListProperty<SambaApplet> SambaDevice::applets()
{
	return QQmlListProperty<SambaApplet>(this, m_applets);
}

int SambaDevice::appletCount() const
{
	return m_applets.length();
}

SambaApplet *SambaDevice::applet(int index) const
{
	return m_applets.at(index);
}

SambaApplet* SambaDevice::applet(const QString& name) const
{
	foreach(SambaApplet* applet, m_applets) {
		if (applet->name() == name)
			return applet;
	}
	return 0;
}
