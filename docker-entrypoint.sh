#!/bin/bash

#set -e

GPU_DEVICE=$(/usr/local/nvidia/bin/nvidia-xconfig --query-gpu-info | grep PCI | awk -F : '{ print $2":"$3":"$4":"$5 }')
/usr/local/nvidia/bin/nvidia-xconfig -a --busid $GPU_DEVICE --allow-empty-initial-configuration --use-display-device=None --virtual=1920x1200

exec /usr/bin/xpra start --daemon=no --start-child="$@"
