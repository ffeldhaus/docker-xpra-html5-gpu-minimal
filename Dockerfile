FROM ffeldhaus/docker-xpra-html5-minimal

LABEL version="0.5"
LABEL maintainer="florian.feldhaus@gmail.com"

ARG VIRTUALGL_VERSION=2.6.80

RUN apt-get update && apt-get install -y \
    curl \
    libegl1-mesa \
    libxv1 && \
    curl -fsSL -O https://s3.amazonaws.com/virtualgl-pr/dev/linux/virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    rm virtualgl_${VIRTUALGL_VERSION}_amd64.deb && \
    apt-get remove -y --purge curl && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# nvidia-container-runtime
ENV NVIDIA_DRIVER_CAPABILITIES all

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json

COPY docker-entrypoint.sh /docker-entrypoint.sh

# ensure that all OpenGL applications started via vglrun are using video mode for best display quality in HTML5 client
RUN echo "\nclass-instance:vglrun=video" >> /usr/share/xpra/content-type/50_class.conf

# passing the command does not work currently 
#CMD ["/opt/VirtualGL/bin/vglrun","-d","/dev/dri/card0","/opt/VirtualGL/bin/glxspheres64"]