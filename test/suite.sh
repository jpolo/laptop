#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.."
source "./src/_functions.sh"

# Try to run brew installation
_laptop_ensure_brew
