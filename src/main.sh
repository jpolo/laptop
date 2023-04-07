#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

# Bootstrap
_laptop_bootstrap
ensure_file_template "zprofile" ~/.zprofile
ensure_file_template "zshrc" ~/.zshrc

# Installation
_laptop_shell zsh  "$LAPTOP_SOURCE_DIR/0-configure-shell.zsh"
_laptop_shell zsh "$LAPTOP_SOURCE_DIR/1-configure-all.zsh"

einfo "ZSH configuration was potentially modified, please close/open a new terminal to see changes."
