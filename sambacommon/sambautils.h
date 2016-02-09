#ifndef SAMBA_UTILS_H
#define SAMBA_UTILS_H

#include "sambacommon.h"
#include "sambabytearray.h"
#include <QObject>

class SAMBACOMMONSHARED_EXPORT SambaUtils : public QObject
{
	Q_OBJECT

public:
	explicit SambaUtils();

	Q_INVOKABLE void sleep(int secs);
	Q_INVOKABLE void msleep(int msecs);
	Q_INVOKABLE void usleep(int usecs);

	Q_INVOKABLE SambaByteArray *createByteArray(int length);
	Q_INVOKABLE SambaByteArray *readUrl(const QString& fileUrl);
	Q_INVOKABLE SambaByteArray *readFile(const QString& fileName);
	Q_INVOKABLE bool writeFile(const QString& fileName, const SambaByteArray& data);
};

#endif // SAMBA_UTILS_H
