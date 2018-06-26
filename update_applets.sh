#!/bin/bash

TOP_DIR=$(pwd)
APPLET_DIR="$TOP_DIR/src/plugins/device"
BUILD_DIR="$TOP_DIR/softpack"

[ -n "$GIT_REPOSITORY" ] || GIT_REPOSITORY="https://github.com/atmelcorp/atmel-software-package.git"
[ -n "$GIT_COMMIT" ] || [ -n "$GIT_TAG" ] || GIT_COMMIT="65146d0e62565d23acaa80354ce7a329f2a1137d"

pushd $APPLET_DIR
APPLETS=$(find . -type f -name "*-generic_*.bin")
popd

rm -fr $BUILD_DIR 2>/dev/null
mkdir -p $BUILD_DIR || exit 1
pushd $BUILD_DIR
if [ -n "$GIT_COMMIT" ]; then
    git clone $GIT_REPOSITORY . || exit 1
    git checkout $GIT_COMMIT || exit 1
elif [ -n "$GIT_TAG" ]; then
    git clone --single-branch -b $GIT_TAG $GIT_REPOSITORY . || exit 1
    GIT_COMMIT=$(git rev-list -n 1 $GIT_TAG)
else
    echo "missing either GIT_COMMIT or GIT_TAG"
    popd
    exit 1
fi
popd

REGEXP="^.*applet-\([a-z]\+\)_\([0-9a-z]\+\)-generic_\([a-z]\+\).bin$"
for APPLET in $APPLETS; do
    INSTALL_DIR=$(dirname $APPLET_DIR/$APPLET)
    NAME=$(echo $APPLET | sed -e "s/$REGEXP/\1/")
    TARGET=$(echo $APPLET | sed -e "s/$REGEXP/\2/")-generic
    VARIANT=$(echo $APPLET | sed -e "s/$REGEXP/\3/")

    make -C $BUILD_DIR/samba_applets/$NAME TARGET=$TARGET VARIANT=$VARIANT RELEASE=1 || exit 1
    cp -f $BUILD_DIR/samba_applets/$NAME/build/$TARGET/$VARIANT/applet-${NAME}_${TARGET}_${VARIANT}.bin $INSTALL_DIR/ || exit 1
done

rm -fr $BUILD_DIR

# Update README.txt files to describe how to compile applets
find $APPLET_DIR -type f -iname "README.txt" -exec sed -i -e "s/^Commit: [[:xdigit:]]\+$/Commit: $GIT_COMMIT/g" -e "s/git checkout [[:xdigit:]]\+$/git checkout $GIT_COMMIT/g" {} \+
