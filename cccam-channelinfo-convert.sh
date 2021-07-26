#!/bin/sh

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FILES_DIR="$BASE_DIR/files"

cp /dev/null $FILES_DIR/etc/CCcam.prio
rm $FILES_DIR/etc/CCcam.prio

cat $FILES_DIR/etc/CCcam.channelinfo | while read line; do
	echo -n "P: " >> $FILES_DIR/etc/CCcam.prio
	echo -n $line | sed 's/ .*//' >> $FILES_DIR/etc/CCcam.prio
	echo -n "\t#" >> $FILES_DIR/etc/CCcam.prio
	echo $line | cut -d ' ' -f 2- >> $FILES_DIR/etc/CCcam.prio
done

exit 0
