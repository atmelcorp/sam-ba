#ifndef SAMBABYTEARRAY_H
#define SAMBABYTEARRAY_H

#include "sambacommon.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaByteArray : public QObject
{
	Q_OBJECT

public:
	explicit SambaByteArray();
	explicit SambaByteArray(const QByteArray& data);
	explicit SambaByteArray(const SambaByteArray& data);

	Q_INVOKABLE int length() {
		return m_data.length();
	}

	Q_INVOKABLE SambaByteArray *mid(int index, int len) {
		return new SambaByteArray(m_data.mid(index, len));
	}

	Q_INVOKABLE void append(SambaByteArray* other) {
		m_data.append(other->m_data);
	}

	Q_INVOKABLE bool readUrl(const QString& fileUrl);
	Q_INVOKABLE bool readFile(const QString& fileName);
	Q_INVOKABLE bool writeFile(const QString& fileName) const;

	inline const QByteArray &constData() const
	{
		return m_data;
	}

private:
	QByteArray m_data;
};

#endif // SAMBABYTEARRAY_H
