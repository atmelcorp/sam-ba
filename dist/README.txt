# Atmel SAM-BA - SAM Boot Assistant
Release version: 3.2.1
Release date: 2017-10

## Overview

The SAM-BA tool is a programming tool for the Atmel MPUs/MCUs.

Please note that all presented APIs / command line options are subject to
change from one version to another.

## License

SAM-BA is provided under the GNU General Public License version 2 only. A copy
of the license can be found in the LICENSE.txt file.

The sources are available on GitHub:
https://github.com/atmelcorp/sam-ba

## Supported Platforms

This release supports the following platforms:
- Windows 32-bit and 64-bit
- Linux x86_64

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

- examples/sam9xx5: examples for SAM9xx5 (NAND, SD/MMC, SPI Flash)
- examples/sama5d2: examples for SAMA5D2 (boot configuration, NAND, SD/MMC, SPI/QSPI Flash)
- examples/sama5d3: examples for SAMA5D3 (NAND, SD/MMC, SPI Flash)
- examples/sama5d4: examples for SAMA5D4 (NAND, SD/MMC, SPI Flash, PIO)
- examples/samv71: examples for SAMV71 MCU series (SAME70/S70/V70/V71)
- examples/scripting: examples relating to the QML scripting environment

Please see README.txt file in each example directory for more information.
