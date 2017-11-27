#!/bin/bash

if [ "$1" = "--help" ] || [ "$1" = "help" ] || [ "$1" = "" ]; then
    echo "Usage: $0 [--help] <release|beta|clean> [cache]"
    echo -e "\tThe first parameter determines the release or beta build of SPIN."
    echo -e "\tUse '$0 <release|beta> cache' to enable build caching for faster rebuilding."
    echo -e "\tUse '$0 clean' to clear existing cached files."    
    exit
fi

# Source general configuration
source $(dirname $BASH_SOURCE)/../config-release.sh

# Define docker volume names that are used for caching
CCACHE="spin-ccache"
LCACHE="spin-ledesrc"

# Run docker to compile the spin/valibox software
TIMEFORMAT='Finished in %lR.'

if [ "$1" = "release" ]; then
    BUILD_VERSION="release"    
elif [ "$1" = "beta" ]; then
    BUILD_VERSION="beta"
    source $(dirname $BASH_SOURCE)/../config-beta.sh
elif [ "$1" = "clean" ]; then
    # We use a little trick here, volume names should be at least 2 characters
    #  long, so trying to remove '_' compensates the situation in which
    #  both CCACHE and LCACHE are empty.
    $ENV docker volume rm _ $CCACHE $LCACHE 2>/dev/null >/dev/null &&\
    echo "Remaining cache volumes removed." ||\
    echo "No cache volumes found."
    exit 0
else
    echo "Error: please specify the version to build, or use --help for help."
    exit 1
fi

echo "Building SPIN ($BUILD_VERSION) $VERSION to bin/"
# Make sure bin/ directory is removed. Docker will create it.
$ENV rm -rf bin/

if [ "$2" = "cache" ]; then
    time {
        $ENV docker build . -t spinbuild && docker run \
            -v $CCACHE:$DIRECTORY/cache \
            -v $LCACHE:$LEDEDIR \
            -v "$(pwd)"/bin:$OUTPUT/sidn \
            --rm -it \
            spinbuild \
            $DIRECTORY/scripts/build-$BUILD_VERSION.sh
    }
else
    time {
        $ENV docker build . -t spinbuild && docker run \
            -v "$(pwd)"/bin:$OUTPUT/sidn \
            --rm -it \
            spinbuild \
            $DIRECTORY/scripts/build-$BUILD_VERSION.sh
    }
fi
echo "The output can be found in the bin/ directory"
