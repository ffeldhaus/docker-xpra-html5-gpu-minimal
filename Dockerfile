FROM docker-xpra-html5

LABEL version="0.1"
LABEL maintainer="florian.feldhaus@gmail.com"

# copy xpra config file
RUN mkdir xpra
COPY ./xpra.conf xpra/xpra.conf

RUN apt-get update && apt-get install -y --no-install-recommends \
    	libglvnd0 \
	libgl1 \
	libglx0 \
	libegl1 \
	libgles2 && \
    rm -rf /var/lib/apt/lists/*

COPY 10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
