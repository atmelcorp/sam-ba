/**
* \file
*
* Implementation of XMODEM transfer protocols
*
*/

/*----------------------------------------------------------------------------
* Headers
*----------------------------------------------------------------------------*/

#include <board.h>

/*----------------------------------------------------------------------------
* Local definitions
*----------------------------------------------------------------------------*/

/** The definitions are followed by the X/Ymodem protocol */
#define XMDM_SOH 0x01 /**< Start of heading */
#define XMDM_EOT 0x04 /**< End of text */
#define XMDM_ACK 0x06 /**< Acknowledge */
#define XMDM_NAK 0x15 /**< negative acknowledge */
#define XMDM_CAN 0x18 /**< Cancel */
#define XMDM_ESC 0x1b /**< Escape */

#define CRC16POLY 0x1021 /**< CRC 16 polynom */
#define PKTLEN_128 128 /**< Packet length */

/*----------------------------------------------------------------------------
* Local variables
*----------------------------------------------------------------------------*/

/** Xmodem transfer error indicator */
int8_t cRrror;

/*----------------------------------------------------------------------------
* Local functions
*----------------------------------------------------------------------------*/

/**
* \brief Transmit the character through xmodem protocol.
*
* \param ucChar Character to be transmitted.
*/
static void XMODEM_PutChar(uint8_t ucChar)
{
	UART_PutChar(ucChar);
}

/**
* \brief Get the character through xmodem protocol.
*
* \return The character received
*/
static uint8_t XMODEM_GetChar(void)
{
	return (uint8_t)UART_GetChar();
}

/**
* \brief Get calculated crc value for xmodem transfer
*
* \param ucChar The CRC original character.
* \param uwCrc Calculated CRC value.
* \return Calculated CRC value.
*/
static uint16_t XMODEM_GetCrc(int8_t ucChar, uint16_t uwCrc)
{
	uint16_t uwCmpt;

	uwCrc = uwCrc ^ (int32_t) ucChar << 8;

	for (uwCmpt= 0; uwCmpt < 8; uwCmpt++)
	{
		if (uwCrc & 0x8000)
			uwCrc = uwCrc << 1 ^ CRC16POLY;
		else
			uwCrc = uwCrc << 1;
	}

	return (uwCrc & 0xFFFF);
}

/**
* \brief Get bytes through xmodem protocol.
*
* \param pData Pointer to the data buffer.
* \param dwLength Length of data expected.
* \return Bytes received
*/
static uint16_t XMODEM_Getbytes(int8_t *pData, uint32_t dwLength)
{
	uint16_t uwCrc = 0;
	uint32_t dwCpt;
	int8_t cChar;

	for (dwCpt = 0; dwCpt < dwLength; ++dwCpt)
	{
		cChar = XMODEM_GetChar();

		if (cRrror)
			return 1;

		uwCrc = XMODEM_GetCrc(cChar,uwCrc);

		*pData++ = cChar;
	}

	return uwCrc;
}

/**
* \brief Get a packet through xmodem protocol
*
* \param pData Pointer to the data buffer.
* \param ucSno Sequnce number.
* \return 0 for sucess and other value for xmodem error
*/
static int32_t XMODEM_GetPacket(int8_t *pData, uint8_t ucSno)
{
	uint8_t cpSeq[2];
	uint16_t uwCrc, uwXcrc;

	XMODEM_Getbytes((int8_t*)cpSeq, 2);

	uwXcrc = XMODEM_Getbytes(pData, PKTLEN_128);

	if(cRrror)
		return (-1);

	/* An "endian independent way to combine the CRC bytes. */
	uwCrc = (unsigned short)XMODEM_GetChar() << 8;
	uwCrc += (unsigned short)XMODEM_GetChar();

	if(cRrror == 1)
		return (-1);

	if ((uwCrc != uwXcrc) || (cpSeq[0] != ucSno) || (cpSeq[1] != (uint8_t) ((~(uint32_t)ucSno)&0xff)))
	{
		XMODEM_PutChar(XMDM_CAN);
		return(-1);
	}

	return(0);
}

/*----------------------------------------------------------------------------
* Exported functions
*----------------------------------------------------------------------------*/
/**
* \brief Receive the files through xmodem protocol
*
* \param pBuffer Pointer to received buffers
* \return 0 for sucess and other value for xmodem error
*/
extern uint32_t XMODEM_ReceiveFile(int8_t *pBuffer)
{
	int32_t wTimeout;
	int8_t cChar;
	int32_t wDone;
	uint8_t ucSno = 0x01;
	uint32_t dwWavSize = 0;

	/* Wait and put 'C' till start xmodem transfer */
	while(1)
	{
		XMODEM_PutChar('C');

		wTimeout = (BOARD_MCK/10);

		while(!(UART_IsRxReady())&&wTimeout)
			wTimeout--;

		if (UART_IsRxReady())
			break;
	}

	/* Begin to receive the data */
	cRrror = 0;
	wDone = 0;
	while(wDone == 0)
	{
		cChar = (int8_t)XMODEM_GetChar();

		if(cRrror)
			return 0;

		switch(cChar)
		{
		/* Start of transfer */
		case XMDM_SOH:
			wDone = XMODEM_GetPacket(pBuffer+dwWavSize, ucSno);
			if(cRrror)
				return 0;

			if (wDone == 0)
			{
				ucSno++;
				dwWavSize += PKTLEN_128;
			}

			XMODEM_PutChar(XMDM_ACK);

			break;

			/* End of transfer */
		case XMDM_EOT:
			XMODEM_PutChar(XMDM_ACK);
			wDone = dwWavSize;
			break;

		case XMDM_CAN:
		case XMDM_ESC:
		default:
			wDone = -1;
			break;
		}
	}
	return dwWavSize;
}
