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
