# Building SAM-BA


## Pre-requisites

- Qt 5.9.3

  Download from [qt.io](http://www.qt.io/download-open-source/#section-3).

  For Linux, use package "Qt 5.9.3 for Linux 64-bit".

  For Windows, use package "Qt 5.9.3 for Windows 32-bit"

- J-Link SDK 6.32f

  Download from SEGGER, not publicly available.

  Other versions can probably be used, but the qmake file for the J-Link plugin
must be changed accordingly.


## Building

The build uses 3 mandatory directories and 1 optional directory:

- source code directory (git checkout)
- build directory
- release directory
- J-Link SDK Linux directory (optional)

We will refer to these directories in the rest of this documentation as
{SRCDIR}, {BUILDDIR}, {RELEASEDIR} and {JLINKSDKDIR}.
{RELEASEDIR} and {JLINKSDKDIR} must be absolute paths.

The Qt installation directory will be referred to as {QTDIR}.

SAM-BA can be built either using command-line commands or using Qt Creator.

### Using command line

#### Linux

1. Clone/checkout the source in {SRCDIR}
``git clone https://github.com/atmelcorp/sam-ba {SRCDIR}``

2. Create directory {BUILDDIR}
``mkdir -p {BULDDIR}``

3. Set an empty EXTRA_QMAKE_OPTIONS variable
``EXTRA_QMAKE_OPTIONS=""``

4. (optional) Append the JLINKSDKPATH option into the EXTRA_QMAKE_OPTIONS variable
``EXTRA_QMAKE_OPTIONS="$EXTRA_QMAKE_OPTIONS JLINKSDKPATH={JLINKSDKDIR}"``

5. Go in directory {BUILDDIR} and run
``{QTDIR}/5.9.3/gcc_64/bin/qmake $EXTRA_QMAKE_OPTIONS -r {SRCDIR}/sam-ba.pro``.
This will generate the makefiles in {BUILDDIR} from the qmake templates in the
source tree.

6. Go in directory {BUILDDIR} and run
``make INSTALL_ROOT={RELEASEDIR} install``

7. The release material should now be present in {RELEASEDIR} directory.

#### Windows

1. Clone/Checkout the source in {SRCDIR}

2. Create directory {BUILDDIR}
``mkdir {BUILDDIR}``

3. Set EXTRA_QMAKE_OPTIONS variable to a ' ' (single space)
``set "EXTRA_QMAKE_OPTIONS= "``

4. (optional) Append the JLINKSDKPATH option into the EXTRA_QMAKE_OPTIONS variable
``set "EXTRA_QMAKE_OPTIONS=%EXTRA_QMAKE_OPTIONS% JLINKSDKPATH='{JLINKSDKDIR}'"``

5. Go in directory {BUILDDIR} and run:
``{QTDIR}\5.9.3\mingw53_32\bin\qmake %EXTRA_QMAKE_OPTIONS% -r {SRCDIR}\sam-ba.pro``.
This will generate the makefiles in {BUILDDIR} from the qmake templates in the
source tree.

5. Add MingW32 directory to path:
``set path=%path%;{QTDIR}\Tools\mingw530_32\bin``

6. Go in directory {BUILDDIR} and run:
``mingw32-make INSTALL_ROOT={RELEASEDIR} install``

7. The release material should now be present in {RELEASEDIR} directory.


### Using Qt Creator

#### Linux

1. Start Qt Creator

2. Load ``sam-ba.pro`` from {SRCDIR}

3. Select kit "Desktop Qt 5.9.3 GCC 64bit" and click "Configure Project"

4. (optional) In the bottom of the left toolbar, click on the "sam-ba Release"
or " sam-ba Debug" icon to select the desired build configuration.

5. Click on the "Projects" icon in the left toolbar

6. Select "Build" from the "Build | Run" selector below the kit name

7. Set the "Build directory:" field to {BUILDDIR}

8. (optional) In the "Build Steps" section, click on the "Details" button of
the "qmake" step to expand its detailed options.
Then set the "Additional arguments:" field to ``JLINKSDKPATH={JLINKSDKDIR}``

9. Select "Run" from the "Build | Run" selector below the kit name

10. In "Deployment", click "Add Deploy Step" and select "Make"

11. In "Make arguments:" fields, type:
``INSTALL_ROOT={RELEASEDIR} install``
  
12. In the "Build" menu, click "Build All"

13. Click "4 Compile Output" at the bottom of the screen to see the build
progress

14. Once the build is complete, in the "Build" menu, click "Deploy All"

15. The release material should now be present in {RELEASEDIR} directory.

#### Windows

1. Start Qt Creator

2. Load ``sam-ba.pro`` from {SRCDIR}

3. Select kit "Desktop Qt 5.9.3 MingW 32 bit" and click "Configure Project"

4. (optional) In the bottom of the left toolbar, click on the "sam-ba Release"
or " sam-ba Debug" icon to select the desired build configuration.

5. Click on the "Projects" icon in the left toolbar

6. Select "Build" from the "Build | Run" selector below the kit name

7. Set the "Build directory:" field to {BUILDDIR}

8. (optional) In the "Build Steps" section, click on the "Details" button of
the "qmake" step to expand its detailed options.
Then set the "Additional arguments:" field to ``"JLINKSDKPATH='{JLINKSDKDIR}'"``

9. Select "Run" from the "Build | Run" selector below the kit name

10. In "Deployment", click "Add Deploy Step" and select "Make"

11. In "Make arguments:" fields, type:
``INSTALL_ROOT={RELEASEDIR} install``

12. In the "Build" menu, click "Build All"

13. Click "4 Compile Output" at the bottom of the screen to see the build
progress

14. Once the build is complete, in the "Build" menu, click "Deploy All"

15. The release material should now be present in {RELEASEDIR} directory.

