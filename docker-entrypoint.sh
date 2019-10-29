#!/bin/bash

#set -e

GPU_DEVICE=$(/usr/local/nvidia/bin/nvidia-xconfig --query-gpu-info | grep PCI | awk -F : '{ print $2":"$3":"$4":"$5 }')
/usr/local/nvidia/bin/nvidia-xconfig -a --allow-empty-initial-configuration --busid $GPU_DEVICE --xconfig /etc/xpra/xorg.conf --output-xconfig /etc/xpra/xorg.conf

exec /usr/bin/xpra start --daemon=no --start-child="$@"

cat /tmp/Xorg.S1.log
