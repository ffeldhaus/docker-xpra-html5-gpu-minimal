# Minimal docker image to run xpra with HTML 5 client and GPU accelerated OpenGL support

This docker image provides remote access using [xpra](https://xpra.org/) to an xterm via a HTML5 based web client listening on port 14500 for websocket connections.

In addition to the docker-xpra-html5-minimal image, this image also provides GPU accelerated OpenGL support using [VirtualGL](https://virtualgl.org/). Currently this only works with NVIDIA GPUs and requires the NVIDIA drivers to be installed on the docker host. 

## Prerequisites for the docker host

For Ubuntu the NVIDIA drivers can be installed with:

```sh
LATEST_NVIDIA_DRIVER_VERSION=$(apt-cache search nvidia-headless | grep -E 'nvidia-headless-[0-9]+ ' | sed -r -e 's/nvidia-headless-([0-9]+).*/\1/' | tail -1)
sudo apt-get update && sudo apt-get install -y nvidia-headless-$LATEST_NVIDIA_DRIVER_VERSION nvidia-utils-$LATEST_NVIDIA_DRIVER_VERSION libnvidia-gl-$LATEST_NVIDIA_DRIVER_VERSION
```

Additionally it is required to install the NVIDIA Container Toolkit which enables GPU sharing with docker containers (see [NVIDIA Container Toolkit
](https://github.com/NVIDIA/nvidia-docker) for details and instructions for other distributions).

```sh
# install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
reboot
```

It is very important to reboot your system after installing the prerequisites before running a container with this image!

## Example

By default, the container uses the default self-signed certificate to offer SSL. If you want to specify your own certificate, you can overwrite the default SSL certificate with the docker parameter similar to --mount type=bind,source="$(pwd)"/ssl-cert.pem,target=/etc/xpra/ssl-cert.pem,readonly (make sure to put the ssl-cert.pem file in the current folder or modify the source path).

By default, Xpra can only be accessed using a password. The default password is xpra, but can be changed by setting the environment variable XPRA_PW (e.g. using the `docker run` parameter `-e XPRA_PW=mypassword`).

It is useful to automatically restart the container on failures using the `--restart unless-stopped` parameter.

When running a container, the GPU needs to be passed to the container including the `/dev/dri` devices. The following is an example to run the glxspheres64 demo on the first GPU of the docker host:

```sh
docker run --gpus 1 --device=/dev/dri -p 14500:14500 ffeldhaus/docker-xpra-html5-opengl-minimal
```

Then open a browser with the hostname or IP of your docker host:

https://\<hostname OR IP>:14500

Running the image will results in multiple warnings and error messages to be shown from xpra as xpra is trying to use a lot of recommended dependencies which are not included in this image.