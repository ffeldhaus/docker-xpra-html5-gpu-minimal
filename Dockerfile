FROM ffeldhaus/docker-xpra-html5

LABEL version="0.2"
LABEL maintainer="florian.feldhaus@gmail.com"

ARG VIRTUALGL_VERSION=2.6.80

USER root

RUN apt-get update && apt-get install -y \
    curl \
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
    curl -fsSL -O https://s3.amazonaws.com/virtualgl-pr/dev/linux/virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    rm virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    apt-get remove -y --purge curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
        ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
        ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility,video,display

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

# set VirtualGL to only use the (new) EGL backend
 RUN /opt/VirtualGL/bin/vglserver_config +egl

# ensure that the xpra user is in the vglusers group to be able to access the GPUs
RUN usermod --groups vglusers --append xpra

# using xpra user does not work currently
#USER xpra

# passing the command does not work currently 
#CMD ["/opt/VirtualGL/bin/vglrun","-d","/dev/dri/card0","/opt/VirtualGL/bin/glxspheres64"]