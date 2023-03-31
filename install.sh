#!/usr/bin/env bash

RELEASE="master"
DOWNLOAD="https://github.com/jpolo/laptop/archive/$RELEASE.tar.gz"
PACKAGE_NAME=laptop-installer
PACKAGE_ARCHIVE="$PACKAGE_NAME.tar.gz"
DOWNLOAD_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'laptop-installer')

set -e

echo '==================================='
echo 'Laptop installer'
echo '==================================='
echo

# Remove old laptop playbook
if [[ ! -x $DOWNLOAD_DIR/$PACKAGE_ARCHIVE ]]; then
	echo "[Info] Remove $PACKAGE_NAME playbook"
	rm -rf $DOWNLOAD_DIR$PACKAGE_NAME*
fi


# Download and run laptop playbook
echo "[Info] Download $PACKAGE_NAME playbook"
cd $DOWNLOAD_DIR
curl -fsSL -o $PACKAGE_ARCHIVE $DOWNLOAD
mkdir $DOWNLOAD_DIR$PACKAGE_NAME
tar -zxf $PACKAGE_ARCHIVE --directory $DOWNLOAD_DIR$PACKAGE_NAME --strip-components=1

# Modify the PATH
# This should be subsequently updated in shell settings
export PATH=/usr/local/bin:$PATH


echo "[Info] Run $PACKAGE_NAME playbook"
cd $DOWNLOAD_DIR$PACKAGE_NAME
$DOWNLOAD_DIR$PACKAGE_NAME/scripts/play

