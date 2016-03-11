# Atmel SAM-BA 3.0 release
Release verson: 3.0
Release date: 2015-12

## Overview

This SAM-BA version comes as an early delivery and all presented APIs / command line options are subject to change.

### Supported Platforms

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

This release contains the following examples:

- sama5d2/boot-config: Sample script to display and change boot settings on "SAMA5D2 XPLAINED ULTRA" board
- sama5d2/serialflash: Sample script to flash a linux environment on the "SAMA5D2 XPLAINED ULTRA" board (SPI SerialFlash).
- sama5d2/qspiflash: Sample script to flash a linux environment on the "SAMA5D2 XPLAINED ULTRA" board (QSPI Flash).
- sama5d4/ledblink: Sample script to toggle some PIO on "SAMA5D4-EK" board
- samv7/flash: Sample script to program the internal flash of SAMV7 MCUs.

Please see README.txt file in each example directory for more information.
