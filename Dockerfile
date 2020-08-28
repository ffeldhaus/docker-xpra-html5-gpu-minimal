FROM ffeldhaus/docker-xpra-html5

LABEL version="0.2"
LABEL maintainer="florian.feldhaus@gmail.com"

ARG VIRTUALGL_VERSION=2.6.80

USER root

RUN apt-get update && apt-get install -y \
        libxau6 \
        libxdmcp6 \
        libxcb1 \
        libxext6 \
        libx11-6 \
    	libglvnd0 \
	libgl1 \
	libglx0 \
	libegl1 \
    libegl1-mesa \
	libgles2 \
        libxv1 && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O https://s3.amazonaws.com/virtualgl-pr/dev/linux/virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    rm -f /tmp/virtualgl_${VIRTUALGL_VERSION}_amd64.deb

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
        ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
        ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility,video,display

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
