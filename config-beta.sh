source $(dirname $BASH_SOURCE)/config-release.sh
# Override from release version
DATE=`date +%Y-%m-%d-%H%M`
VERSION="beta-$DATE"
LEDE_COMMIT=6aa4b97a8a4e4d07895682e47184c5d49441b1bb
TYPE="beta"

# Github sources
GIT_SPIN=https://github.com/SIDN/spin.git
GIT_PKGS=https://github.com/SIDN/sidn_openwrt_pkgs.git
