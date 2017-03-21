/*
 * Copyright (c) 2017, Atmel Corporation.
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

.pragma library

/* --- Boot Parameters Indexes --- */

/*! \qmlproperty int BootCfg::SECURITY
    \brief Boot configuration index for the Security Bit. */
var SECURITY = 0

/*! \qmlproperty int BootCfg::BOOTMODE
    \brief Boot configuration index for the Boot Mode. */
var BOOTMODE = 1

/*! \qmlproperty int BootCfg::TCM
    \brief Boot configuration index for TCM Configuration. */
var TCM = 2

/* --- Boot Parameters Values --- */

/*! \qmlproperty int BootCfg::SECURITY_DISABLED
    \brief Boot configuration value for the Security Bit (Disabled). */
var SECURITY_DISABLED = 0

/*! \qmlproperty int BootCfg::SECURITY_ENABLED
    \brief Boot configuration value for the Security Bit (Enabled). */
var SECURITY_ENABLED = 1

/*! \qmlproperty int BootCfg::BOOTMODE_MONITOR
    \brief Boot configuration value for the Boot Mode (SAM-BA Monitor). */
var BOOTMODE_MONITOR = 0

/*! \qmlproperty int BootCfg::BOOTMODE_FLASH
    \brief Boot configuration value for the Boot Mode (Boot from Flash). */
var BOOTMODE_FLASH = 1

/*! \qmlproperty int BootCfg::TCM_DISABLED
    \brief Boot configuration value for the TCM Configuration (Disabled). */
var TCM_DISABLED = 0

/*! \qmlproperty int BootCfg::TCM_32KB
    \brief Boot configuration value for the TCM Configuration (32KB/32KB). */
var TCM_32KB = 1

/*! \qmlproperty int BootCfg::TCM_64KB
    \brief Boot configuration value for the TCM Configuration (64KB/64KB). */
var TCM_64KB = 2

/*! \qmlproperty int BootCfg::TCM_128KB
    \brief Boot configuration value for the TCM Configuration (128KB/128KB). */
var TCM_128KB = 3
