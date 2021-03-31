# SPIN builderfile for Dockerfile
# This produces a docker container that allows you to build SPIN software
#   and/or images based on OpenWRT.
#
# Requirements:
# - Docker
# - Diskspace (at least 26GB at the time of writing)
#
#  
# Build: docker build -t spinbuildenv .
#
# Copy work-files: docker cp spindata.c spinbuilder:/build/build/spin/src/spind/spindata.c 
#
# Copy final images, for example:
# docker create --name spintmp spinbuildenv
#       Or, interactive: docker run -it --name spintmp spinbuildenv /bin/bash 
# docker cp spintmp:/build/valibox-spin-builder/valibox_release ./
# docker rm spinbuilder
# 

# Use an official Debian stable release
FROM debian:latest

# Set the working directory to /app
WORKDIR /build

# Grub may fuck up things, tell it to shut up
ARG DEBIAN_FRONTEND=noninteractive

# Allow unsafe compilation as root (should not be needed anymore?)
#ARG FORCE_UNSAFE_CONFIGURE=1

# Install all requirements for building SPIN
RUN apt-get update && apt-get install -y \
    build-essential gcc make autoconf \
    libnfnetlink-dev libnfnetlink0 \
    libmosquitto-dev luarocks \
    git nano curl time \
    luarocks mosquitto lua-bitop lua-posix \
    libncurses5-dev zlib1g-dev gawk python2.7-dev \ 
    ccache libmnl-dev \ 
    libnetfilter-queue-dev libmnl0 \
    libnetfilter-log-dev libnetfilter-log1 \
    libnetfilter-conntrack-dev libldns-dev \
    libnetfilter-queue1 \
    # Extra feeds for openwrt
    libssl-dev libncurses5-dev unzip gawk zlib1g-dev \
    # For packages that are not installed through git
    subversion mercurial \
    # Extra packages, OpenWRT was complaining
    libpam-dev libcap-dev libjansson-dev \
    # python3 for valibox-builder scripts
    python3

# Add build scripts and files to image
ADD . /build/

# Run as user (non root)
RUN groupadd -r app -g 1000 && useradd -u 1000 -r -g app -m -d /app -s /sbin/nologin -c "App user" app && \
    chmod 755 /app && chown -R app:app /build
# Specify the user to execute all commands below
USER app

# Copy valibox build config
RUN cp /build/valibox_build_config /build/valibox-spin-builder/.valibox_build_config

# Clone OpenWRT into directory and build images
RUN cd /build/valibox-spin-builder && ./builder.py -b

CMD ["/bin/bash"]

# Use ENTRYPOINT to allow dynamic commands to run
# Default: build all

