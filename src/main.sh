#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

_laptop-execute bash "$LAPTOP_SOURCE_DIR/0-bootstrap.sh"
_laptop-execute zsh  "$LAPTOP_SOURCE_DIR/1-configure-shell.zsh"
_laptop-execute zsh "$LAPTOP_SOURCE_DIR/2-configure-all.zsh"

echo -e "${COLOR_WARNING}Warning: ZSH configuration was potentially modified, please close/open a new terminal to see changes.${NORMAL}"
