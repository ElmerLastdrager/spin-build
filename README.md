# Building Valibox/SPIN for OpenWRT

This repository contains some of the build scripts to build and publish the SPIN software for OpenWRT.
These scripts allow you to compile SPIN for OpenWRT yourself.
The output will be an OpenWRT image that you can upload on a compatible device.

Clone this repository, initiate the submodule, build the environment and compile, e.g.:

    git clone --recursive-submodules https://github.com/ElmerLastdrager/spin-build

These scripts allow you to build your own beta version based on the project's master branch.

## Configuration
The repository comes pre-configured for a GL.Inet AR150 mini router.
If you want to build SPIN for an OS other than OpenWRT, you may want to browse to [the Valibox builder repository](https://github.com/SIDN/valibox-spin-builder) instead.
Additionally, that is also the place where you can read about the configuration options of the valibox\_build\_options file.

## Build and compile
Assuming you've got Docker installed and have plenty of available disk space (+- 26 GiB will do), you may run the following command to construct a Docker image with the build environment and compile an Valibox image with SPIN:

    docker build -t spinbuildenv .

_(this may take a long time)_

## Extract results
Once the image has been build, you can extract the output by first creating a temporary container:

    docker create --name spintmp spinbuildenv
    docker cp spintmp:/build/valibox-spin-builder/valibox_release ./
    docker rm spinbuilder

This will create a directory valibox\_release in the repository's directory with the images in there.
For example:

    $ ls -1 valibox_release/gl-ar150 
    1.10-bridge-beta-202103171615.info.txt
    1.11-bridge-beta-202103251603.info.txt
    1.11-bridge-beta-202103291325.info.txt
    sidn_valibox_gl-ar150_1.10-bridge-beta-202103171615.bin
    sidn_valibox_gl-ar150_1.11-bridge-beta-202103251603.bin
    sidn_valibox_gl-ar150_1.11-bridge-beta-202103291325.bin

You may now [install](https://valibox.sidnlabs.nl/en/download/#installation-guide-for-gl-inet-devices) the `.bin` file on your AR150 mini router. 

At this moment, you can delete the SPIN build environment docker image if you do not want to reuse it:

     docker image rm spinbuildenv
