# Local options for use in our scripts
DIRECTORY=/build
LEDEDIR=$DIRECTORY/lede-source
OUTPUT=$DIRECTORY/bin
VERSION="1.4.0"
# LEDE_COMMIT=907d8703f492bca533743c327ffe60a7405aee28 # Jelte-versie
LEDE_COMMIT=6aa4b97a8a4e4d07895682e47184c5d49441b1bb
ENV=/usr/bin/env

# Options for both us and subprocesses
# Stop complaining of configure about being root
export FORCE_UNSAFE_CONFIGURE=1
# Always use ccache
export CONFIG_CCACHE=y
export PATH=/usr/lib/ccache:$PATH
