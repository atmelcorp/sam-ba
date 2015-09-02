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

SambaByteArray::SambaByteArray(const QByteArray& data)
	: QObject(0), m_data(data)
{

}

SambaByteArray::SambaByteArray(const SambaByteArray& data)
	: QObject(0), m_data(data.m_data)
{

}

bool SambaByteArray::readUrl(const QString &fileUrl)
{
	return readFile(QUrl(fileUrl).toLocalFile());
}

// TODO add more error checking ?
bool SambaByteArray::readFile(const QString &fileName)
{
	QFile file(fileName);

	if (!file.open(QIODevice::ReadOnly))
	{
		qCCritical(sambaLogCore, "Error: Could not open file '%s' for reading", fileName.toLocal8Bit().constData());
		m_data.clear();
		return false;
	}

	m_data = file.readAll();
	file.close();

	return true;
}

// TODO add more error checking ?
bool SambaByteArray::writeFile(const QString& fileName) const
{
	QFile file(fileName);

	if (!file.open(QIODevice::WriteOnly))
	{
		qCCritical(sambaLogCore, "Error: Could not open file '%s' for writing", fileName.toLocal8Bit().constData());
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
