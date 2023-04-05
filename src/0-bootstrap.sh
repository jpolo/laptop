#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
source "$SCRIPT_DIR/_functions.sh"

_laptop_bootstrap
ensure_file_template "zprofile" ~/.zprofile
ensure_file_template "zshrc" ~/.zshrc
