#!/usr/bin/env bash
#
# For a development install where your changes are immediately available. Run
# after a normal install.
set -euo pipefail

if [ $USER != "root" ]; then
    echo "You must run this script as root."
    exit 1
fi

THIS_DIR="$( cd "$(dirname "$0")"; pwd -P )"
SRC_ROOT=$(readlink -f "$THIS_DIR/..")
INSTALL_DIR='/usr/local'


ln -sf $SRC_ROOT/intuos4oled.py $INSTALL_DIR/bin/intuos4oled.py

mkdir -p $INSTALL_DIR/lib/intuos4oled
ln -sf $SRC_ROOT/init.sh $INSTALL_DIR/lib/intuos4oled/init.sh
ln -sf $SRC_ROOT/intuos4daemon.py $INSTALL_DIR/lib/intuos4oled/intuos4daemon.py


echo "Development install complete. Re-run \`install.sh\` to revert to a normal install."
