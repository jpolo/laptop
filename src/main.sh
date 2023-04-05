#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

bash -i "$LAPTOP_SOURCE_DIR/0-bootstrap.sh"
zsh -i "$LAPTOP_SOURCE_DIR/1-configure-shell.zsh"
zsh -i "$LAPTOP_SOURCE_DIR/2-configure-all.zsh"

