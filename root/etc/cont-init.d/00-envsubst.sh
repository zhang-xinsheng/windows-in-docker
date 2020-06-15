#!/usr/bin/with-contenv bash

set -eu
set -o pipefail

if [ "$PATH_PREFIX" = "/" ]
then
  export SOCKET_PREFIX=""
else
  export SOCKET_PREFIX="$PATH_PREFIX"
fi

TEMP="$(envsubst '${PATH_PREFIX},${SOCKET_PREFIX}' < /etc/nginx/nginx.conf)"
printf '%s' "$TEMP" > /etc/nginx/nginx.conf

export PAGE_PREFIX="${SOCKET_PREFIX:1}/"
TEMP="$(envsubst '${PAGE_PREFIX},${PAGE_TITLE},${RECON_DELAY},${VNC_RESIZE}' < /novnc/index.html)"
printf '%s' "$TEMP" > /novnc/index.html

TEMP="$(envsubst '${VIRTBR_INTERNAL},${VIRTBR_NAME}' < /vmrc/network.xml)"
printf '%s' "$TEMP" > /vmrc/network.xml

TEMP="$(envsubst '${VIRTBR_NAME}' < /vmrc/lxd-init.yml)"
printf '%s' "$TEMP" > /vmrc/lxd-init.yml

