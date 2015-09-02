#ifndef SAMBA_OBJECT_H
#define SAMBA_OBJECT_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaObject : public QObject
{
	Q_OBJECT

	Q_PROPERTY(QString tag READ tag WRITE setTag NOTIFY tagChanged)
	Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
	Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)

public:
	explicit SambaObject(QObject *parent = 0);

	QString tag() const { return m_tag; }
	void setTag(QString tag) { m_tag = tag; emit tagChanged(); }

	QString name() const { return m_name; }
	void setName(QString name) { m_name = name; emit nameChanged(); }

	QString description() const { return m_description; }
	void setDescription(QString description) { m_description = description; emit descriptionChanged(); }

signals:
	void tagChanged();
	void nameChanged();
	void descriptionChanged();

protected:
	QString m_tag, m_name, m_description;
};

#endif // SAMBA_OBJECT_H
