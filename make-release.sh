#!/bin/bash

if [ "$1" = "--help" ] || [ "$1" = "help" ]; then
    echo "Usage: $0 [clean|cache]"
    echo -e "\tWithout parameters, this script builds SPIN."
    echo -e "\tUse 'cache' to enable build caching for faster rebuilding."
    echo -e "\tUse 'clean' to clear existing cached files."    
    exit
fi

# Source general configuration
source $(dirname $BASH_SOURCE)/config-release.sh

# Define docker volume names that are used for caching
CCACHE="spin-ccache"
LCACHE="spin-ledesrc"

# Run docker to compile the spin/valibox software
TIMEFORMAT='Finished in %lR.'

if [ "$1" = "clean" ]; then
    # We use a little trick here, volume names should be at least 2 characters
    #  long, so trying to remove '_' compensates the situation in which
    #  both CCACHE and LCACHE are empty.
    $ENV docker volume rm _ $CCACHE $LCACHE &&\
    echo "Remaining cache volumes removed." ||\
    echo "No cache volumes found."
else
    echo "Building RELEASE version $VERSION to bin/"
    # Make sure bin/ directory is removed. Docker will create it.
    $ENV rm -rf bin/

    if [ "$1" = "cache" ]; then
        time {
            $ENV docker build . -t spinbuild && docker run \
                -v $CCACHE:$DIRECTORY/cache \
                -v $LCACHE:$LEDEDIR -v "$(pwd)"/bin:$OUTPUT/sidn \
                --rm -it \
                spinbuild \
                $DIRECTORY/scripts/build-release.sh
        }
    else
        time {
            $ENV docker build . -t spinbuild && docker run \
                -v "$(pwd)"/bin:$OUTPUT/sidn \
                --rm -it \
                spinbuild \
                $DIRECTORY/scripts/build-release.sh
        }
    fi
    echo "The output can be found in the bin/ directory"
fi
