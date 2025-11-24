#!/usr/bin/env bash

#==============================================================================
# 🔧 These variable can be changed to customize a forked laptop repository
#
RELEASE="main"
REPOSITORY_NAME=${REPOSITORY_NAME:-"jpolo/laptop"}
# ⬇ Uncomment this if you want to force default install profile
# export LAPTOP_PROFILE=${LAPTOP_PROFILE:-"default"}
export LAPTOP_GIT_REMOTE="https://github.com/$REPOSITORY_NAME.git"

#==============================================================================
# 🔶 Do not change the content below
#
DOWNLOAD="https://github.com/$REPOSITORY_NAME/archive/$RELEASE.tar.gz"
PACKAGE_NAME=laptop-installer
PACKAGE_ARCHIVE="$PACKAGE_NAME.tar.gz"
DOWNLOAD_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'laptop-installer')

set -euo pipefail

echo '==================================='
echo 'Laptop installer'
echo '==================================='
echo

# Remove old laptop playbook
if [[ ! -x "$DOWNLOAD_DIR/$PACKAGE_ARCHIVE" ]]; then
  echo "[Info] Clean previous $PACKAGE_NAME"
  rm -rf "$DOWNLOAD_DIR$PACKAGE_NAME"*
fi

# Download and run laptop playbook
echo "[Info] Download $PACKAGE_NAME"
cd "$DOWNLOAD_DIR"
curl -fsSL -o "$PACKAGE_ARCHIVE" "$DOWNLOAD"
mkdir "$DOWNLOAD_DIR$PACKAGE_NAME"
tar -zxf "$PACKAGE_ARCHIVE" --directory "$DOWNLOAD_DIR$PACKAGE_NAME" --strip-components=1

# Modify the PATH
# This should be subsequently updated in shell settings
# export PATH=/usr/local/bin:$PATH

echo "[Info] Run $PACKAGE_NAME"
cd "$DOWNLOAD_DIR$PACKAGE_NAME"
# LAYOUT_PROFILE= will be asked during installation
LAPTOP_BOOTSTRAP=true "$DOWNLOAD_DIR$PACKAGE_NAME/bin/laptop" setup

echo "[Info] Please close your terminal to apply the changes"
