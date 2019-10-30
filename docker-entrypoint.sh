#!/bin/bash

#set -e

GPU_DEVICE=$(/usr/local/nvidia/bin/nvidia-xconfig --query-gpu-info | grep PCI | awk -F : '{ print $2":"$3":"$4":"$5 }')
/usr/local/nvidia/bin/nvidia-xconfig -a --busid $GPU_DEVICE --allow-empty-initial-configuration --output-xconfig=/usr/share/X11/xorg.conf.d/20-nvidia.conf
# ensure nvidia X11 driver is present, may want to move to Dockerfile
cp /usr/lib/x86_64-linux-gnu/nvidia-430/xorg/nvidia_drv.so /usr/lib/xorg/modules/drivers/

/usr/bin/xpra start --daemon=no --start-child="$@"

cat /tmp/Xorg.*

sleep infinity
