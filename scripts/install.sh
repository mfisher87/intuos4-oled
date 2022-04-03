#!/bin/sh -eu
#
# to be run as
# sudo ./install.sh $USER
# This is part of intuos4oled
# It install the python script to /usr/local/bin,
# the init script to /usr/local/lib/intuos4oled
# the udev rules to /etc/udev/rules.d
# and tries to autostart the daemon for the user's session
# and starts it.

# Uncomment for debug output:
# set -x

if [ $USER != "root" ]; then
    echo "You must run this script as root."
    exit 1
fi
if ! [ `which at` ]; then
    echo "You should install the 'at' program first."
    exit 1
fi

THIS_DIR="$( cd "$(dirname "$0")"; pwd -P )"
SRC_ROOT=$(readlink -f "$THIS_DIR/..")
INSTALL_DIR='/usr/local'
user="$1"

if [ -z "$user" ]; then
    echo "Error: no user provided. Type 'sudo ./install \$USER'"
    exit 1
fi
if [ "$user" == "root" ]; then
    echo "The positional argument must _not_ be 'root'. Pass a non-root user."
    exit 1
fi

# Try acting as the passed in user:
su $user -c "/bin/true"

cd $SRC_ROOT

# Set permissions
chmod 755 intuos4oled.py
chmod 755 init.sh

# Install scripts
cp intuos4oled.py $INSTALL_DIR/bin/
mkdir -p $INSTALL_DIR/lib/intuos4oled
cp init.sh $INSTALL_DIR/lib/intuos4oled/
cp intuos4daemon.py $INSTALL_DIR/lib/intuos4oled/

# Setup udev rules
cp 99-wacom.rules /etc/udev/rules.d/99-wacom.rules
udevadm control --reload-rules && udevadm trigger

# If there is no compiled configuration present, install the sample one
su $user -c 'if ! [ -e $HOME/.intuos ]; then cp sample.sync $HOME/.intuos; fi'

# If an autostart directory exists, autostart the daemon
su $user -c 'if [ -d $HOME/.config/autostart ]; then cp intuos4daemon.desktop $HOME/.config/autostart/; fi'

# Start the daemon now
su $user -c '/sbin/start-stop-daemon -S --background --exec /usr/local/lib/intuos4oled/intuos4daemon.py'

echo "Installation completed. You may now plug the Intuos in."
