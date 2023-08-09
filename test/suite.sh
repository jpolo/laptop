#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.."
source "./src/_functions.sh"

mkdir "test_data"
cd "test_data"

# Try to run brew installation
_laptop_ensure_brew

# Test ensure_package
ensure_package "asdf"
ensure_package "asdf"

# Test ensure_asdf_plugin
ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test ensure_asdf_tool
ensure_asdf_tool "nodejs" "lts"
ensure_asdf_tool "nodejs" "lts"

# Test ensure_directory
ensure_directory "./folder_create/"
ensure_directory "./folder_create/"

# Test ensure_file
ensure_file "./test_file_create"
ensure_file "./test_file_create"
