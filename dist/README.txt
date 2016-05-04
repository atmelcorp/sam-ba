# Atmel SAM-BA - SAM Boot Assistant
Release version: 3.1.1
Release date: 2016-04

## Overview

The SAM-BA tool is a programming tool for the Atmel MPUs/MCUs.

Please note that all presented APIs / command line options are subject to
change from one version to another.

### Supported Platforms

This release supports the following platforms:
- Windows 32-bit and 64-bit
- Linux x86_64

### News

The 3.1.1 release adds:
- NAND Flash support for the SAMA5D2
- SD/MMC support for the SAMA5D2
- Enhanced command line support (see doc/cmdline.html for documentation)

Several small changes where made to the QML API, please see the provided examples.
Notable changes:
- SAM-BA QML API modules version is 3.1
- configuration declaration for SAMA5D2 is less verbose. Default for the
  SAMA5D2 device is to be unconfigured, but the "sama5d2-xplained" board
  property can be set to get the same configuration as previous version.
- boot configuration on the SAMA5D2 now uses an applet and a different syntax.

## Contents

### Directory Architecture

- doc:
  Documentation for SAM-BA (command-line and QML API)
  Please open doc/index.html

- lib:
  Executable files and libraries (Linux only)

- qml/
  QML Plugins (devices, communication, etc.)

- examples/
  All examples

### Examples

This release contains several examples:

- examples/sama5d2: examples for SAMA5D2 (boot configuration, SPI/QSPI Flash, SD/MMC, NAND)
- examples/sama5d4: examples for SAMA5D4 (only a script toggling a PIO for now)
- examples/samv7: examples for SAMx7 MCU series (SAMV70, SAMV71, SAME70)
- examples/scripting: examples relating to the QML scripting environment

Please see README.txt file in each example directory for more information.
