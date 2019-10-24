#!/bin/bash

set -e

GPU_DEVICE=$(/usr/local/nvidia/bin/nvidia-xconfig --query-gpu-info | grep PCI | awk -F : '{ print $2":"$3":"$4":"$5 }')
/usr/local/nvidia/bin/nvidia-xconfig -a --allow-empty-initial-configuration --busid $GPU_DEVICE

su - xpra

# first arg is `-f` or `--some-option`
if [ "${1:0:1}" = '-' ]; then
	set -- xpra start "$@"
fi

exec "$@"
