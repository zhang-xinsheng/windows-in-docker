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

TEMP="$(envsubst '${VIRT_NAT_NAME},${VIRT_MACVTAP_NAME}' < /vmrc/nat.xml)"
printf '%s' "$TEMP" > /vmrc/nat.xml

TEMP="$(envsubst '${VIRT_MACVTAP_NAME}' < /vmrc/macvtap.xml)"
printf '%s' "$TEMP" > /vmrc/macvtap.xml

