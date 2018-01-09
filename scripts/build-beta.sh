#!/bin/bash

cp $(dirname $BASH_SOURCE)/../config-beta.sh \
   $(dirname $BASH_SOURCE)/../config.sh

source $(dirname $BASH_SOURCE)/../config.sh

$ENV ccache -o cache_dir=/build/cache &&\

SPINSRC=$DIRECTORY/spin-source
SIDNSRC=$DIRECTORY/sidn_pkgs

cd $DIRECTORY

# Empty output directory
rm -rf $OUTPUT/packages $OUTPUT/targets
mkdir -p $OUTPUT/sidn

# ---------------------------------------------------------------
# Step 1: build spin daemon and kernel module.
# Makes .tar and computes md5sum
# ---------------------------------------------------------------

# PROBLEM: how do we upload the .tar? 
# Maybe include from local file system instead of remote URL?

# Obtain SPIN source (for the moment from github)
# FIXME: allow compilation from local directory
if [ ! -d "$SPINSRC/.git" ]; then
    $ENV git clone --quiet $GIT_SPIN $SPINSRC
else
    cd $SPINSRC &&\
    $ENV git pull
fi

cd $SPINSRC
rm -f /tmp/hash

# Compile spind and kernel module
# Use our own KERNELPATH, to avoid docker confusion with 'uname -a'
export KERNELPATH=$(/usr/bin/find /lib/modules -name build | head -n 1)
SPINVERSION=`cat VERSION`
BNAME="spin-${SPINVERSION}"

mkdir -p /tmp/${BNAME} &&\
cp -r * /tmp/${BNAME}/ &&\
(cd /tmp/${BNAME}; $ENV autoreconf --install && ./configure && $ENV make -j &&\
    $ENV make distclean && rm -rf lua/tests && rm -rf src/tests) &&\
(cd /tmp; tar -czvf ${BNAME}.tar.gz ${BNAME}) &&\
rm -rf /tmp/${BNAME} &&\
$ENV shasum -a 256 /tmp/${BNAME}.tar.gz > /tmp/hash

HASHRAW=`cat /tmp/hash`
HASHARR=($HASHRAW)

if [ ! -z "$HASHRAW" ]; then
    HASH=${HASHARR[0]}
    FILENAME=${HASHARR[1]}    
else
    echo "ERROR: unable to proceed, could not compile SPIN package"
    exit 1
fi

# Move generated tar to output directory
mv $FILENAME $OUTPUT/sidn/$(basename $FILENAME)
echo "Compiled $FILENAME with hash $HASH"

# ---------------------------------------------------------------
# Step 2: build LEDE packages
# Basically, this means inserting md5 sum of step 1.
# Also, point to local repository
# ---------------------------------------------------------------

if [ ! -d "$SIDNSRC/.git" ]; then
    $ENV git clone --quiet $GIT_PKGS $SIDNSRC
    cd $SIDNSRC
else
    cd $SIDNSRC &&\
    $ENV git pull
fi

# Insert correct HASH into Makefile
$ENV sed "/^PKG_HASH/s/.*/PKG_HASH:=$HASH/" $SIDNSRC/spin/Makefile \
    > $SIDNSRC/spin/Makefile.new &&\
cp $SIDNSRC/spin/Makefile.new $SIDNSRC/spin/Makefile &&\

# Make file location local
ESCAPEDIR="${OUTPUT//\//\\/}"
$ENV sed "/^PKG_SOURCE_URL/s/.*/PKG_SOURCE_URL:=file:\/\/$ESCAPEDIR\/sidn\//" $SIDNSRC/spin/Makefile \
    > $SIDNSRC/spin/Makefile.new &&\
cp $SIDNSRC/spin/Makefile.new $SIDNSRC/spin/Makefile &&\

# Change package version to beta
$ENV sed "/^PKG_VERSION/s/.*/PKG_VERSION:=$SPINVERSION/" $SIDNSRC/spin/Makefile \
    > $SIDNSRC/spin/Makefile.new &&\
cp $SIDNSRC/spin/Makefile.new $SIDNSRC/spin/Makefile &&\

# Output Makefile in case it needs to be uploaded
cp $SIDNSRC/spin/Makefile $OUTPUT/sidn/Makefile.spin


# ---------------------------------------------------------------
# Step 3: build LEDE binary
# ---------------------------------------------------------------
# Point to local repository


#
# define Build/Prepare
#         mkdir -p $(PKG_BUILD_DIR)
#         $(CP) ./src/* $(PKG_BUILD_DIR)/
# endef

echo "Obtaining LEDE source"
if [ ! -d "$LEDEDIR/.git" ]; then
    $ENV git clone --quiet https://github.com/lede-project/source.git $LEDEDIR
else
    cd $LEDEDIR
    $ENV git pull
fi

# Compile lede
$DIRECTORY/scripts/lede-build-release.sh

$ENV python2.7 $DIRECTORY/scripts/lede-sidn-create_release.py -v $VERSION \
    $LEDEDIR/VALIBOX_CHANGELOG.txt $OUTPUT/sidn

rm -rf $OUTPUT/packages $OUTPUT/targets
