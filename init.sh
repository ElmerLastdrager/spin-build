#!/bin/bash
# Initialise container

source config-release.sh

# Make sure we are in /build
if [ ! -d "$DIRECTORY/cache" ]; then
    mkdir -p $DIRECTORY/cache
fi

# Make sure output directory exists
if [ ! -d "$OUTPUT" ]; then
  mkdir -p $OUTPUT
fi

# Configure CCache
if [ ! -e "/home/dev/.ccache/ccache.conf" ]; then
    mkdir -p /home/dev/.ccache
    ln -s /build/cache/ccache.conf /home/dev/.ccache/ccache.conf
fi

if [ $(id -u) = 0 ]; then
    # If we are root, change permissions to all volumes
    mkdir -p $LEDEDIR &&\
    chown -R dev:dev /home/dev/.ccache $DIRECTORY $LEDEDIR
fi
