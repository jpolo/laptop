#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

# Ensure ZSH Configuration
ensure_file_template "zshrc.d/00-init.sh" "$XDG_DATA_HOME/zsh/00-init.sh"
