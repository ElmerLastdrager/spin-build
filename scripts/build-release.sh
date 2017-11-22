#!/bin/bash

source $(dirname $BASH_SOURCE)/../config-release.sh

$ENV ccache -o cache_dir=/build/cache &&\

cd $DIRECTORY

# Empty output directory
rm -rf $OUTPUT/*

# ---------------------------------------------------------------
# Step 1: build spin daemon and kernel module.
# ---------------------------------------------------------------

# In this production version, we do not need to recompile spin and the kernel
#   modules. It will be downloaded from the spin website.

# ---------------------------------------------------------------
# Step 2: build LEDE packages
# ---------------------------------------------------------------

# Not needed for production version

# ---------------------------------------------------------------
# Step 3: build LEDE binary
# ---------------------------------------------------------------

# Alternative: clone entire repository
echo "Obtaining LEDE source"
if [ ! -d "$LEDEDIR/.git" ]; then
    $ENV git clone https://github.com/lede-project/source.git $LEDEDIR
else
    cd $LEDEDIR
    $ENV git pull
fi

# Compile lede
$DIRECTORY/scripts/lede-build-release.sh

# Fix output??? FIXME
mkdir -p $OUTPUT/sidn
$ENV python2.7 $DIRECTORY/scripts/lede-sidn-create_release.py -v $VERSION \
    $LEDEDIR/VALIBOX_CHANGELOG.txt $OUTPUT/sidn

rm -rf $OUTPUT/packages $OUTPUT/targets
