#!/bin/sh

set -ex

PUID=${PUID:-0}
PGID=${PGID:-0}

if [ -e "/config/gdrive.conf" ]; then
  echo "existing google-drive-ocamlfuse config found"
else
  if [ -z "${CLIENT_ID}" ]; then
    echo "no CLIENT_ID found -> EXIT"
    exit 1
  elif [ -z "${CLIENT_SECRET}" ]; then
    echo "no CLIENT_SECRET found -> EXIT"
    exit 1
  elif [ -z "$VERIFICATION_CODE" ]; then
    echo "no VERIFICATION_CODE found -> EXIT"
    exit 1
  else
    echo "initilising google-drive-ocamlfuse..."
    echo "${VERIFICATION_CODE}" | \
      google-drive-ocamlfuse \
        -config /config/gdrive.conf \
        -label gdrive \
        -f \
        -skiptrash \
        -headless \
        -id "${CLIENT_ID}.apps.googleusercontent.com" \
        -secret "${CLIENT_SECRET}"
  fi
fi

echo "mounting at ${DRIVE_PATH}"
google-drive-ocamlfuse  ${DRIVE_PATH} \
  -config /config/gdrive.conf \
  -o uid=${PUID},gid=${PGID},allow_root \
  -label gdrive \
  -f \
  -skiptrash \
  -headless
