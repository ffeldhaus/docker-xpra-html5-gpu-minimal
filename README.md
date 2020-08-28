# docker-xpra-html5-opengl

This docker image provides remote access using [xpra](https://xpra.org/) to an xterm via a HTML5 based web client listening on port 14500 for websocket connections.

In addition to the docker-xpra-html5 image, this image also provides OpenGL acceleration using [VirtualGL](https://virtualgl.org/). Currently this only works with NVIDIA GPUs and requires the NVIDIA drivers to be installed on the docker host. For Ubuntu the NVIDIA drivers can be installed with (see [NVIDIA Container Toolkit
](https://github.com/NVIDIA/nvidia-docker) for details)

```sh
# install recommended NVIDIA drivers
sudo apt-get update && sudo apt-get install -y ubuntu-drivers-common
sudo ubuntu-drivers devices
sudo ubuntu-drivers autoinstall
reboot

# install NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker
```

When running a container, the GPU needs to be passed to the container including the `/dev/dri` devices. The following is an example to run the glxspheres64 demo on the first GPU of the docker host:

```sh
docker run --gpus 1 --device=/dev/dri -p 14500:14500 ffeldhaus/docker-xpra-html5-opengl "vglrun -d /dev/dri/card0 /opt/VirtualGL/bin/glxspheres64"
```

Then open a browser with the hostname or IP of your docker host:

https://\<hostname OR IP>:14500