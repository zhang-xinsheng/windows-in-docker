### ### ### ### ### ### ### ### ###
### ### ### ### ### ### ### ### ###
FROM archlinux:latest AS build

## AUR
RUN pacman -Sy --needed --noconfirm \
    base-devel git
COPY build /


## Drivers
RUN git clone --depth=1 https://aur.archlinux.org/virtio-win.git && \
    cd virtio-win && \
    chgrp nobody "$PWD" && \
    chmod g+ws "$PWD" && \
    sudo -u nobody makepkg -si


### ### ### ### ### ### ### ### ###
### ### ### ### ### ### ### ### ###
FROM archlinux:latest

ARG S6_VER="2.0.0.1"
ARG NO_VNC_VER="1.1.0"
ARG WEB_SOCK_VER="0.9.0"

RUN mkdir /_install


## S6 Overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_VER}/s6-overlay-amd64.tar.gz /_install
RUN tar xzf /_install/s6-overlay-amd64.tar.gz -C / --exclude="./bin" && \
    tar xzf /_install/s6-overlay-amd64.tar.gz -C /usr ./bin
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
ENTRYPOINT ["/init"]


## KVM-QEMU
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    qemu-headless \
    libvirt \
    virt-install \
    dmidecode
EXPOSE 5900


## Bridging
RUN pacman -S --noconfirm \
    lxd \
    iproute2 \
    bridge-utils


## NOVNC
ADD https://github.com/novnc/noVNC/archive/v${NO_VNC_VER}.zip /_install
ADD https://github.com/novnc/websockify/archive/v${WEB_SOCK_VER}.zip /_install
RUN cd /_install && \
    pacman -S --noconfirm unzip nginx gettext inetutils python-pip && \
    pip3 install numpy && \
    unzip v${NO_VNC_VER}.zip && \
    unzip v${WEB_SOCK_VER}.zip && \
    mv noVNC-${NO_VNC_VER} /novnc && \
    mv websockify-${WEB_SOCK_VER} /novnc/utils/websockify
ENV PATH_PREFIX=/ \
    VNC_RESIZE=scale \
    RECON_DELAY=250 \
    PAGE_TITLE=KVM
EXPOSE 8080


## Dependencies
COPY root /usr/share/virtio/ /drivers/
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    VIRTBR_NAME=virtbr0 \
    LXDBR_NAME=lxdbr0 \
    VM_NAME=wind
VOLUME ["/config", "/install"]


## Cleanup
# RUN pacman -Sc --noconfirm && \
#     rm -r /_install

