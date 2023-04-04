#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

/bin/bash "$LAPTOP_SOURCE_DIR/0-bootstrap.sh"
zsh "$LAPTOP_SOURCE_DIR/1-configure-shell.sh"
zsh "$LAPTOP_SOURCE_DIR/2-configure-all.sh"

