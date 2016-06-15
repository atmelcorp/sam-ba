Atmel SAM-BA
------------

# Overview

This repository contains the sources of the Atmel SAM-BA tool.

This tool is built using Qt5 and is command-line only for now.

The sources are hosted on [GitHub](https://github.com/atmelcorp/sam-ba).

## License

SAM-BA sources are provided under the GNU General Public License version 2
only. A copy of the license can be found in the LICENSE file.

## Supported Platforms

The main supported platform for SAM-BA are Windows and Linux.

The following versions are built on each release:

- Windows x86 32-bit (this binary can also be run on 64-bit Windows)
- Linux x86 64-bit

Unsupported builds can also be provided for Linux x86 32-bit and ARMv7.

## Directory Architecture

- dist
  Misc. files required for the binary package

- doc
  Files related to documentation generation

- examples
  Examples provided in the binary package

- src
  C++ and QML source code

## Building SAM-BA

A comprehensive guide for building SAM-BA can be found in [BUILD.md](BUILD.md).
