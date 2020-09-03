#!/bin/bash

# ensure that xpra user is part of vglusers group which must have been set for /dev/dri/card0
VGLUSERS_GID=$(ls -ln /dev/dri/card0 | awk '{print $4}')
groupadd --gid $VGLUSERS_GID vglusers
usermod --groups $VGLUSERS_GID --append xpra

# start xpra with command specified in dockerfile as CMD or passed as parameter to docker run
exec /usr/bin/xpra start --daemon=no --start-child="$@"