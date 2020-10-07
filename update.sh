#!/bin/sh

CONFIG_DIR="/"
CONFIG_REPO="https://github.com/Noltari/openspa-config/archive/master.tar.gz"
CONFIG_VERSION_FILE="/media/hdd/config-version"
CONFIG_VERSION_URL="https://raw.githubusercontent.com/Noltari/openspa-config/master/version"

PICONS_DIR="/media/hdd/picon/"
PICONS_REPO="https://github.com/Noltari/openspa-picons/archive/master.tar.gz"
PICONS_VERSION_FILE="/media/hdd/picons-version"
PICONS_VERSION_URL="https://raw.githubusercontent.com/Noltari/openspa-picons/master/version"

update_config () {
	echo "Config update started..."

	mkdir $TMP_DIR/config-repo
	wget --no-verbose -O - $CONFIG_REPO | tar xz --strip 1 -C $TMP_DIR/config-repo
	rsync -avh $TMP_DIR/config-repo/files/ $CONFIG_DIR
	cp $TMP_DIR/config-repo/version $CONFIG_VERSION_FILE

	echo "Config update done."
}

update_picons () {
	echo "Picons update started..."

	mkdir $TMP_DIR/picons-repo
	wget --no-verbose -O - $PICONS_REPO | tar xz --strip 1 -C $TMP_DIR/picons-repo
	rsync -avh --include="*.png" --exclude="*" $TMP_DIR/picons-repo/ $PICONS_DIR --delete
	cp $TMP_DIR/picons-repo/version $PICONS_VERSION_FILE

	echo "Picons update done."
}

main () {
	# Switch to a new temp dir
	TMP_DIR="$(mktemp -d)"
	cd $TMP_DIR

	# Fetch and update config
	if [ -f "$CONFIG_VERSION_FILE" ]; then
		local_version="$(cat $CONFIG_VERSION_FILE)"
		wget -O config-version $CONFIG_VERSION_URL
		remote_version="$(cat config-version)"
		if [ "$local_version" -lt "$remote_version" ]; then
			update_config
		fi
	else
		update_config
	fi

	# Fetch and update picons
	if [ -f "$PICONS_VERSION_FILE" ]; then
		local_version="$(cat $PICONS_VERSION_FILE)"
		wget -O picons-version $PICONS_VERSION_URL
		remote_version="$(cat config-version)"
		if [ "$local_version" -lt "$remote_version" ]; then
			update_picons
		fi
	else
		update_picons
	fi

	# Remove temp directory
	cd $TMP_DIR/..
	rm -rf $TMP_DIR
}

main $@

exit 0
