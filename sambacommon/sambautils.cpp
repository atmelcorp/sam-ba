#include "sambautils.h"
#include <QThread>

SambaUtils::SambaUtils()
	: QObject(0)
{

}

void SambaUtils::sleep(int secs)
{
	QThread::sleep(secs);
}

void SambaUtils::msleep(int msecs)
{
	QThread::msleep(msecs);
}

void SambaUtils::usleep(int usecs)
{
	QThread::usleep(usecs);
}

SambaByteArray *SambaUtils::createByteArray(int length)
{
	return new SambaByteArray(length);
}

SambaByteArray *SambaUtils::readUrl(const QString& fileUrl)
{
	SambaByteArray *array = new SambaByteArray();
	if (array->readUrl(fileUrl))
		return array;
	delete array;
	return NULL;
}

SambaByteArray *SambaUtils::readFile(const QString& fileName)
{
	SambaByteArray *array = new SambaByteArray();
	if (array->readFile(fileName))
		return array;
	delete array;
	return NULL;
}

bool SambaUtils::writeFile(const QString& fileName, const SambaByteArray& data)
{
	return data.writeFile(fileName);
}
