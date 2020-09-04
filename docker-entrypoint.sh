#!/bin/bash

# configure dbus
dbus-uuidgen > /var/lib/dbus/machine-id
mkdir -p /var/run/dbus
dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

# ensure that xpra user is part of vglusers group which must have been set for /dev/dri/card0
VGLUSERS_GID=$(ls -ln /dev/dri/card0 | awk '{print $4}')
groupadd --gid $VGLUSERS_GID vglusers
usermod --groups $VGLUSERS_GID --append xpra

# start xpra as xpra user with command specified in dockerfile as CMD or passed as parameter to docker run
runuser -l xpra -c '/usr/bin/xpra start --daemon=no --start-child="$@"'