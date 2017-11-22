# SPIN build scripts

This repository contains the build scripts to build and publish the SPIN software.


**scripts/**  
    build scripts for lede, spin, etc  
    main entrance script for docker cmd  

**Dockerfile**
    
**README**  
    Write command examples

<!-- **make-beta.sh**
   Script that builds all beta binaries in `bin/beta/` directory.
   Runs docker with specific bin/ bind mount. -->

**make-release.sh**  
   Script that builds all release binaries in `bin/` directory.  
   Runs docker with specific bin/ bind mount.  

**.gitignore**  
    bin/

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
