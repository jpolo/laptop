#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"
cd "$SCRIPT_DIR/.."
ROOT_DIR=$(pwd)

bootstrap

# Install programs
ensure_package "docker"
ensure_package "drawio"
ensure_package "git"
ensure_package "gpg"
ensure_package "macpass"
ensure_package "mercurial"
ensure_package "notion"
ensure_package "postman"
ensure_package "rclone"
ensure_package "slack"
ensure_package "watchman"

