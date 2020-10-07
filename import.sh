#!/bin/sh

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FILES_DIR="$BASE_DIR/files"

wget -O $FILES_DIR/etc/CCcam.channelinfo https://kos.hdsat.pl/get-16-3.html
wget -O $FILES_DIR/etc/CCcam.prio https://kos.hdsat.pl/get-16-4.html

exit 0
