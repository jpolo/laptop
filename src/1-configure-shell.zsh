#!/usr/bin/env zsh

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

# Ensure ZSH Configuration
ensure_file_template "zshrc.d/00_init.sh" "$XDG_DATA_HOME/zsh/00_init.sh"

