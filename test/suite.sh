#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.."
source "./src/_functions.sh"

mkdir "test_data"
cd "test_data"

# Try to run brew installation
laptop::ensure_brew

# Test laptop::ensure_package
laptop::ensure_package "asdf"
laptop::ensure_package "asdf"

# Test laptop::ensure_asdf_plugin
laptop::ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
laptop::ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test laptop::ensure_asdf_tool
laptop::ensure_asdf_tool "nodejs" "lts"
laptop::ensure_asdf_tool "nodejs" "lts"

# Test laptop::ensure_directory
laptop::ensure_directory "./folder_create/"
laptop::ensure_directory "./folder_create/"

# Test laptop::ensure_file
laptop::ensure_file "./test_file_create"
laptop::ensure_file "./test_file_create"
