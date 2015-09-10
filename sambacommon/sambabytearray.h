#ifndef SAMBABYTEARRAY_H
#define SAMBABYTEARRAY_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaByteArray : public QObject
{
	Q_OBJECT
	Q_PROPERTY(unsigned length READ length NOTIFY lengthChanged)

public:
	explicit SambaByteArray();
	explicit SambaByteArray(const QByteArray& data);
	explicit SambaByteArray(const SambaByteArray& data);

	unsigned length() const {
		return m_data.length();
	}

	void setData(const QByteArray& data)
	{
		m_data = data;
		emit lengthChanged();
	}

	const QByteArray &constData() const
	{
		return m_data;
	}

	Q_INVOKABLE SambaByteArray *mid(unsigned index, unsigned len) const {
		return new SambaByteArray(m_data.mid(index, len));
	}

	Q_INVOKABLE void append(SambaByteArray* other) {
		m_data.append(other->m_data);
		emit lengthChanged();
	}

	Q_INVOKABLE quint8 at(unsigned index) const {
		return m_data.at(index);
	}

	Q_INVOKABLE bool readUrl(const QString& fileUrl);
	Q_INVOKABLE bool readFile(const QString& fileName);
	Q_INVOKABLE bool writeFile(const QString& fileName) const;

signals:
	void lengthChanged();

private:
	QByteArray m_data;
};

#endif // SAMBABYTEARRAY_H
