#!/bin/bash

echo "Getting configuration..."
# Source general configuration
source $(dirname $BASH_SOURCE)/config-release.sh

echo "Building RELEASE version $VERSION to bin/"

# Make sure bin/ directory is removed. Docker will create it.
$ENV rm -rf bin/

# Run docker to compile the spin/valibox software
TIMEFORMAT='Finished in %lR.'
time {
    $ENV docker build . -t spinbuild && docker run -v ccache:$DIRECTORY/cache \
        -v ledesrc:$LEDEDIR -v "$(pwd)"/bin:$OUTPUT/sidn \
        --rm -it spinbuild $DIRECTORY/scripts/build-release.sh
}
echo "The output can be found in the bin/ directory"
