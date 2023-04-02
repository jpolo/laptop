#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"
cd "$SCRIPT_DIR/.."
ROOT_DIR=$(pwd)

bootstrap

# Install programs
ensure_package "android-studio"
ensure_package "chromedriver"
ensure_package "discord"
ensure_package "docker"
ensure_package "drawio"
ensure_package "git"
ensure_package "google-chrome"
ensure_package "gpg"
ensure_package "iterm2"
ensure_package "macpass"
ensure_package "mercurial"
ensure_package "notion"
ensure_package "postman"
ensure_package "rclone"
ensure_package "slack"
ensure_package "tfenv"
ensure_package "watchman"

