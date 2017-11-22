# SPIN build scripts

This repository contains the build scripts to build and publish the SPIN
software.

Clone this repository and run the make-release.sh scripts using bash.

## Usage

The easiest method to start compiling SPIN is to run:
> ./make-release.sh

This does not use caching by default. If you do
want to compile several times and have some disk space to spare (8-10GB), use
> ./make-release.sh cache

If you want to remove the cached volumes, you can run
> ./make-release.sh clean

The output images will be put in a bin/ subdirectory of the current working
 directory.

<!-- ## Contents

**scripts/**
    build scripts for lede, spin, etc
    main entrance script for docker cmd

**Dockerfile**

 **README**
    Write command examples -->

<!-- **make-beta.sh**
   Script that builds all beta binaries in `bin/beta/` directory.
   Runs docker with specific bin/ bind mount. -->

<!-- **make-release.sh**
   Script that builds all release binaries in `bin/` directory.
   Runs docker with specific bin/ bind mount.  -->

<!-- **.gitignore**
    bin/ -->

<!-- # Manual

Handmatig builden bij beta-builds, met volumes en feed-link. Korte uitleg hoe
 dat moet.

Building release:
> docker build . -t spinbuild && docker run -v ccache:/build/cache -v ledesrc:/build/lede-source -v "$(pwd)"/bin:/build/output/sidn --rm -it spinbuild /build/build-release.sh


# Test
To log in to the image and manually run build commands, use the following
 command.

> docker build . -t spinbuild && docker run -v ccache:/build/cache -v ledesrc:/build/lede-source -v "$(pwd)"/output:/build/output/sidn --rm -it spinbuild /bin/bash

 -->
