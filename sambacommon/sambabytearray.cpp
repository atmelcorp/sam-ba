#include "sambacommon.h"
#include "sambabytearray.h"
#include <QUrl>
#include <QFile>
#include <QThread>
#include <QLoggingCategory>

SambaByteArray::SambaByteArray()
	: QObject(0)
{

}

SambaByteArray::SambaByteArray(int length)
	: QObject(0)
{
	m_data.resize(length);
	m_data.fill(0xff);
}

SambaByteArray::SambaByteArray(const QByteArray& data)
	: QObject(0), m_data(data)
{

}

SambaByteArray::SambaByteArray(const SambaByteArray& data)
	: QObject(0), m_data(data.m_data)
{

}

void SambaByteArray::pad(unsigned count, quint8 value)
{
	m_data.append(QByteArray(count, value));
	emit lengthChanged();
}

SambaByteArray *SambaByteArray::mid(unsigned index, unsigned len) const
{
	return new SambaByteArray(m_data.mid(index, len));
}

void SambaByteArray::prepend(SambaByteArray* other)
{
	m_data.prepend(other->m_data);
	emit lengthChanged();
}

void SambaByteArray::append(SambaByteArray* other)
{
	m_data.append(other->m_data);
	emit lengthChanged();
}

quint8 SambaByteArray::readu8(int offset) const
{
	return m_data[offset];
}

void SambaByteArray::writeu8(int offset, quint8 value)
{
	m_data[offset] = value;
}

quint16 SambaByteArray::readu16(int offset) const
{
	return m_data[offset]
			+ (m_data[offset + 1] << 8);
}

void SambaByteArray::writeu16(int offset, quint16 value)
{
	m_data[offset] = value & 0xff;
	m_data[offset + 1] = (value >> 8) & 0xff;
}

quint32 SambaByteArray::readu32(int offset) const
{
	return m_data[offset]
			+ (m_data[offset + 1] << 8)
			+ (m_data[offset + 2] << 16)
			+ (m_data[offset + 3] << 24);
}

void SambaByteArray::writeu32(int offset, quint32 value)
{
	m_data[offset] = value & 0xff;
	m_data[offset + 1] = (value >> 8) & 0xff;
	m_data[offset + 2] = (value >> 16) & 0xff;
	m_data[offset + 3] = (value >> 24) & 0xff;
}

bool SambaByteArray::readUrl(const QString &fileUrl)
{
	return readFile(QUrl(fileUrl).toLocalFile());
}

bool SambaByteArray::readFile(const QString &fileName)
{
	QFile file(fileName);

	if (!file.open(QIODevice::ReadOnly))
	{
		qCDebug(sambaLogCore, "Error: Could not open file '%s' for reading", fileName.toLocal8Bit().constData());
		m_data.clear();
		return false;
	}

	// TODO add more error checking ?
	setData(file.readAll());
	file.close();

	return true;
}

bool SambaByteArray::writeFile(const QString& fileName) const
{
	QFile file(fileName);

	if (!file.open(QIODevice::WriteOnly))
	{
		qCDebug(sambaLogCore, "Error: Could not open file '%s' for writing", fileName.toLocal8Bit().constData());
		return false;
	}

	if (file.write(m_data) != m_data.length())
	{
		file.close();
		return false;
	}

	file.close();
	return true;
}
