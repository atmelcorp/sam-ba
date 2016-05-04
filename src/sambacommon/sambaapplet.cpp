/*
 * Copyright (c) 2015-2016, Atmel Corporation.
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms and conditions of the GNU General Public License,
 * version 2, as published by the Free Software Foundation.
 *
 * This program is distributed in the hope it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 */

#include "sambaapplet.h"

SambaApplet::SambaApplet(QQuickItem* parent)
	: QQuickItem(parent),
	  m_name(""),
	  m_description(""),
	  m_codeUrl(""),
	  m_codeAddr(0),
	  m_mailboxAddr(0),
	  m_traceLevel(5),
	  m_retries(20),
	  m_bufferAddr(0),
	  m_bufferSize(0),
	  m_bufferPages(0),
	  m_pageSize(0),
	  m_memorySize(0),
	  m_memoryPages(0),
	  m_eraseSupport(0),
	  m_paddingByte(0xff)
{
}

QString SambaApplet::name() const
{
	return m_name;
}

void SambaApplet::setName(const QString& name)
{
	m_name = name;
	emit nameChanged();
}

QString SambaApplet::description() const
{
	return m_description;
}

void SambaApplet::setDescription(const QString& description)
{
	m_description = description;
	emit descriptionChanged();
}

QString SambaApplet::codeUrl() const
{
	return m_codeUrl;
}

void SambaApplet::setCodeUrl(const QString& codeUrl)
{
	m_codeUrl = codeUrl;
	emit codeUrlChanged();
}

quint32 SambaApplet::codeAddr() const
{
	return m_codeAddr;
}

void SambaApplet::setCodeAddr(quint32 codeAddr)
{
	m_codeAddr = codeAddr;
	emit codeAddrChanged();
}

quint32 SambaApplet::mailboxAddr() const
{
	return m_mailboxAddr;
}

void SambaApplet::setMailboxAddr(quint32 mailboxAddr)
{
	m_mailboxAddr = mailboxAddr;
	emit mailboxAddrChanged();
}

QQmlListProperty<SambaAppletCommand> SambaApplet::commands()
{
	return QQmlListProperty<SambaAppletCommand>(this, m_commands);
}

bool SambaApplet::hasCommand(const QString& name) const
{
	return command(name) != 0;
}

SambaAppletCommand* SambaApplet::command(const QString& name) const
{
	foreach(SambaAppletCommand* command, m_commands) {
		if (command->name() == name)
			return command;
	}
	return 0;
}

quint32 SambaApplet::traceLevel() const
{
	return m_traceLevel;
}

void SambaApplet::setTraceLevel(quint32 traceLevel)
{
	m_traceLevel = traceLevel;
	emit traceLevelChanged();
}

quint32 SambaApplet::bufferAddr() const
{
	return m_bufferAddr;
}

void SambaApplet::setBufferAddr(quint32 bufferAddr)
{
	m_bufferAddr = bufferAddr;
	emit bufferAddrChanged();
}

quint32 SambaApplet::bufferSize() const
{
	return m_bufferSize;
}

void SambaApplet::setBufferSize(quint32 bufferSize)
{
	m_bufferSize = bufferSize;
	emit bufferSizeChanged();

	if (m_pageSize > 0 && (m_bufferSize != (m_bufferPages * m_pageSize))) {
		m_bufferPages = m_bufferSize / m_pageSize;
		emit bufferPagesChanged();
	}
}

quint32 SambaApplet::bufferPages() const
{
	return m_bufferPages;
}

void SambaApplet::setBufferPages(quint32 bufferPages)
{
	m_bufferPages = bufferPages;
	emit bufferPagesChanged();

	if (m_pageSize > 0 && (m_bufferSize != (m_bufferPages * m_pageSize))) {
		m_bufferSize = m_bufferPages * m_pageSize;
		emit bufferSizeChanged();
	}
}

quint32 SambaApplet::pageSize() const
{
	return m_pageSize;
}

void SambaApplet::setPageSize(quint32 pageSize)
{
	m_pageSize = pageSize;
	emit pageSizeChanged();

	if (m_bufferSize != (m_bufferPages * m_pageSize)) {
		if (m_bufferSize > 0) {
			m_bufferPages = m_bufferSize / m_pageSize;
			emit bufferPagesChanged();
		} else if (m_bufferPages > 0) {
			m_bufferSize = m_bufferPages * m_pageSize;
			emit bufferSizeChanged();
		}
	}

	if (m_memorySize != (m_memoryPages * m_pageSize)) {
		if (m_memorySize > 0) {
			m_memoryPages = m_memorySize / m_pageSize;
			emit memoryPagesChanged();
		} else if (m_memoryPages > 0) {
			m_memorySize = m_memoryPages * m_pageSize;
			emit memorySizeChanged();
		}
	}
}

quint32 SambaApplet::memorySize() const
{
	return m_memorySize;
}

void SambaApplet::setMemorySize(quint32 memorySize)
{
	m_memorySize = memorySize;
	emit memorySizeChanged();

	if (m_pageSize > 0 && (m_memorySize != (m_memoryPages * m_pageSize))) {
		m_memoryPages = m_memorySize / m_pageSize;
		emit memoryPagesChanged();
	}
}

quint32 SambaApplet::memoryPages() const
{
	return m_memoryPages;
}

void SambaApplet::setMemoryPages(quint32 memoryPages)
{
	m_memoryPages = memoryPages;
	emit memoryPagesChanged();

	if (m_pageSize > 0 && (m_memorySize != (m_memoryPages * m_pageSize))) {
		m_memorySize = m_memoryPages * m_pageSize;
		emit memorySizeChanged();
	}
}

quint32 SambaApplet::eraseSupport() const
{
	return m_eraseSupport;
}

void SambaApplet::setEraseSupport(quint32 eraseSupport)
{
	m_eraseSupport = eraseSupport;
	emit eraseSupportChanged();
}

quint8 SambaApplet::paddingByte() const
{
	return m_paddingByte;
}

void SambaApplet::setPaddingByte(quint8 paddingByte)
{
	m_paddingByte = paddingByte;
	emit paddingByteChanged();
}
