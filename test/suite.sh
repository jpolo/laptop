#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1
LAPTOP_HOME=$(pwd)
export LAPTOP_HOME
source "./src/env.sh"

mkdir -p "test_data"
cd "test_data" || exit 1

# Try to run brew installation
laptop::ensure_package "brew"

# Test laptop::ensure_package
laptop::ensure_package "asdf"
laptop::ensure_package "asdf"

# Test laptop::ensure_asdf_plugin
laptop::ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
laptop::ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test laptop::ensure_asdf_tool
laptop::ensure_asdf_tool "nodejs" "latest:20"
laptop::ensure_asdf_tool "nodejs" "latest:20"

# Test laptop::ensure_directory
laptop::ensure_directory "./folder_create/"
laptop::ensure_directory "./folder_create/"

# Test laptop::ensure_file
laptop::ensure_file "./test_file_create"
laptop::ensure_file "./test_file_create"
