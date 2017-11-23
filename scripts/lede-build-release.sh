#!/bin/bash

# First our reset function: this returns the lede directory back to its original
#   state, and then copied spin/valibox and device-specific files.
resetworkdir () {
    cd $LEDEDIR &&\
    cp $DIRECTORY/devices/$1/.config $LEDEDIR/.config &&\
    rm -rf $LEDEDIR/files &&\
    cp -R $DIRECTORY/devices/$1 $LEDEDIR/files &&\
    mkdir -p $LEDEDIR/files/etc &&\
    echo "$VERSION" > $LEDEDIR/files/etc/valibox.version &&\
    # make sure the .config file is up to date
    $ENV make defconfig
}

# Source general configuration
source $(dirname $BASH_SOURCE)/../config.sh

echo "Configuring build environment ($TYPE)"

cd $LEDEDIR &&\

rm -rf $LEDEDIR/bin/*

# Reset repository to specific commit
$ENV git reset --hard $LEDE_COMMIT &&\

# Set feeds and SIDN valibox package
cat $LEDEDIR/feeds.conf.default > $LEDEDIR/feeds.conf &&\
cat $DIRECTORY/devices/feeds-$TYPE.conf >> $LEDEDIR/feeds.conf &&\
cp $DIRECTORY/changelog.txt $LEDEDIR/VALIBOX_CHANGELOG.txt &&\

rm -f $LEDEDIR/dl/spin-*.tar.gz &&\
$LEDEDIR/scripts/feeds update -a &&\
$LEDEDIR/scripts/feeds install -a -p sidn
# FIXME in beta, install all except spin. Or update spin later

# ---------------------------------------------------------------
# Compile for GL Inet AR150
# ---------------------------------------------------------------

# Check out specific commit of LEDE, for this version
echo "Now compiling for GL Inet AR150"
resetworkdir gl-ar150
make -j
$ENV rsync -r $LEDEDIR/bin/ $OUTPUT

echo "Now compiling for GL Inet 6416"
resetworkdir gl-6416
make -j
$ENV rsync -r $LEDEDIR/bin/ $OUTPUT

echo "Now compiling for GL Inet MT300a"
resetworkdir gl-mt300a
make -j
$ENV rsync -r $LEDEDIR/bin/ $OUTPUT

# If all goes okay, the results will all be in the $LEDEDIR/bin/ dir
