FROM ffeldhaus/docker-xpra-html5

LABEL version="0.1"
LABEL maintainer="florian.feldhaus@gmail.com"

ARG VIRTUALGL_VERSION=2.5.2

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
        libxau6 \
        libxdmcp6 \
        libxcb1 \
        libxext6 \
        libx11-6 \
    	libglvnd0 \
	libgl1 \
	libglx0 \
	libegl1 \
	libgles2 \
        libxv1 && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    rm -f /tmp/virtualgl_${VIRTUALGL_VERSION}_amd64.deb

RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

USER xpra

# copy xpra config file
RUN mkdir xpra
COPY ./xpra.conf xpra/xpra.conf

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
        ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
        ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics,utility,video,display

# Required for non-glvnd setups.
ENV LD_LIBRARY_PATH /usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}:/usr/local/nvidia/lib:/usr/local/nvidia/lib64

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
