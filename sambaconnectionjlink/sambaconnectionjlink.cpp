#include "sambaconnectionjlink.h"
#include "sambaconnectionportjlink.h"
#include <QStringList>
#include <JLinkARMDLL.h>

SambaConnectionJlink::SambaConnectionJlink(QObject* parent)
	: SambaConnection(parent)
{
	m_tag = "jlink";
	m_name = "J-Link";
	m_description = "J-Link";
}

SambaConnectionJlink::~SambaConnectionJlink()
{
	if (JLINKARM_IsOpen())
		JLINKARM_Close();
}

void SambaConnectionJlink::refreshPorts()
{
	// TODO keep unchanged ports

	m_ports.clear();

	JLINKARM_EMU_CONNECT_INFO connectInfo[8];
	int numDevs = JLINKARM_EMU_GetList(JLINKARM_HOSTIF_USB, connectInfo, 8);
	for (int i = 0; i < numDevs; i++)
	{
		m_ports.append(new SambaConnectionPortJlink(this, connectInfo[i].SerialNumber));
	}

	emit portsChanged();
}
