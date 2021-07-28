#!/bin/sh

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
FILES_DIR="$BASE_DIR/files"

cp /dev/null $FILES_DIR/etc/CCcam.prio
cp /dev/null $BASE_DIR/oscam.dvapi
cp /dev/null $BASE_DIR/oscam.services
cp /dev/null $BASE_DIR/oscam.srvid2

echo "[Movistar]" > $BASE_DIR/oscam.services
echo "caid = 1810" >> $BASE_DIR/oscam.services
echo "provid =" >> $BASE_DIR/oscam.services
echo -n "srvid =" >> $BASE_DIR/oscam.services

cat $FILES_DIR/etc/CCcam.channelinfo | while read line; do
	echo -n "P: " >> $FILES_DIR/etc/CCcam.prio
	echo -n $line | sed 's/ .*//' >> $FILES_DIR/etc/CCcam.prio
	echo -n "\t#" >> $FILES_DIR/etc/CCcam.prio
	echo $line | cut -d ' ' -f 2- >> $FILES_DIR/etc/CCcam.prio

	echo -n "P: " >> $BASE_DIR/oscam.dvapi
	echo -n $line | sed 's/ .*//' >> $BASE_DIR/oscam.dvapi
	echo -n "\t#" >> $BASE_DIR/oscam.dvapi
	echo $line | cut -d ' ' -f 2- >> $BASE_DIR/oscam.dvapi

	echo -n $line | sed 's/ .*//' | awk '{split($0,a,":"); printf "%s:%s", a[3], a[1]}' >> $BASE_DIR/oscam.srvid2
	echo -n "@000000|" >> $BASE_DIR/oscam.srvid2
	echo -n $line | cut -d ' ' -f 2- | tr -d $'\n' | tr -d '\"' >> $BASE_DIR/oscam.srvid2
	echo "|||Movistar" >> $BASE_DIR/oscam.srvid2

	echo -n $line | sed 's/ .*//' | awk '{split($0,a,":"); printf "%s,", a[3]}' >> $BASE_DIR/oscam.services
done

echo 0000 >> $BASE_DIR/oscam.services

exit 0
