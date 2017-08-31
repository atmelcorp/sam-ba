#!/bin/bash

DEPLOY_DIR=/Volumes/samba_release
SAMBA_MAJOR=3
DIR="samba_release"
SAMBA_ROOT=samba-microchip

# Make a fake enviroment
mount_env(){

if [ ! -d "$SAMBA_ROOT" ];then
mkdir $SAMBA_ROOT
cd $SAMBA_ROOT

mkdir -p qml/SAMBA/Connection/Serial

mkdir -p qml/SAMBA/Connection/JLink

mkdir -p src/plugins/core

cd ..
hdiutil create -srcfolder $SAMBA_ROOT $SAMBA_ROOT.dmg
hdiutil attach $SAMBA_ROOT.dmg

fi


}

umount_env(){
rm -rf $SAMBA_ROOT
umount /Volumes/samba-microchip
rm $SAMBA_ROOT.dmg


}

echo "Start deploying sam-ba application..."

if [ ! -d "$QT_DIR"]
then
    echo "You need to install qt to /Applications"
    exit 1
else
    mount_env

    mkdir -p $DIR

    cd $DIR

    /Applications/Qt5.9/5.9/clang_64/bin/qmake -r $(PWD)/../sam-ba.pro

    make install INSTALL_ROOT=$(PWD)

    ln -s src/sambacommon/libsambacommon.$SAMBA_MAJOR.dylib ./

    ln -s src/sambacommon/libsambacommon.$SAMBA_MAJOR.dylib /Volumes/samba-microchip/libsambacommon.$SAMBA_MAJOR.dylib

    ln -s src/sambacommon/libsambacommon.$SAMBA_MAJOR.dylib /Volumes/samba-microchip/qml/SAMBA/Connection/Serial/libsambacommon.$SAMBA_MAJOR.dylib

    ln -s src/sambacommon/libsambacommon.$SAMBA_MAJOR.dylib /Volumes/samba-microchip/qml/SAMBA/Connection/JLink/libsambacommon.$SAMBA_MAJOR.dylib

    ln -s src/sambacommon/libsambacommon.$SAMBA_MAJOR.dylib /Volumes/samba-microchip/src/plugins/core/libsambacommon.$SAMBA_MAJOR.dylib

    cd qml/SAMBA/Connection/JLink/
    install_name_tool -change Output/Release/x86_64/libjlinkarm.5.2.11.dylib Frameworks/libjlinkarm.5.dylib libsamba_conn_jlink.dylib

    umount_env

    cd ../../../../../

    umount_env
    hdiutil create SAMBA-Microchip.dmg -volname "samba-microchip" -fs HFS+ -srcfolder $DIR

    rm -rf $DIR



fi

echo "Application deployed successfully."
exit 0
