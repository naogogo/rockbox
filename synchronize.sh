#!/bin/bash
#
# Sync stuff with WSL from Windows to iPod
#

set -eux -o pipefail

# Drive letter of iPod
DRIVELETTER="g"

MOUNTPATH="/mnt/rockbox"

# Music folder in Rockbox root, sync there by default
MUSICPATH="${MOUNTPATH}/Music"

SRC="${1}"
DST="${2:-${MUSICPATH}}"

sudo mkdir -p "${MOUNTPATH}"
if mount | grep -E "\s+${MOUNTPATH}\s+" 2> /dev/null; then
  echo "Drive mounted, unmount first"
  exit 1
fi

sudo mount \
  -o noatime,uid=1000,gid=1000,dmask=0022,fmask=0133 \
  -t drvfs "${DRIVELETTER}:" "${MOUNTPATH}"

rsync --verbose --delete --modify-window=2 --update --recursive --omit-dir-times "${SRC}" "${DST}"

sudo umount "${MOUNTPATH}"
