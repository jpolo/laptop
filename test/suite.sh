#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1
LAPTOP_HOME=$(pwd)
export LAPTOP_HOME
export LAPTOP_PROFILE=default
source "./lib/env.sh"

mkdir -p "test_data"
cd "test_data" || exit 1

# Try to run brew installation
laptop_package_ensure "brew"

# Test laptop_package_ensure
laptop_package_ensure "asdf"
laptop_package_ensure "asdf"

# Test laptop_asdf_ensure_plugin
laptop_asdf_ensure_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
laptop_asdf_ensure_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test laptop_asdf_ensure_package
laptop_asdf_ensure_package "nodejs" "latest:20"
laptop_asdf_ensure_package "nodejs" "latest:20"

# Test laptop_directory_ensure
laptop_directory_ensure "./folder_create/"
laptop_directory_ensure "./folder_create/"

# Test laptop_file_ensure
laptop_file_ensure "./test_file_create"
laptop_file_ensure "./test_file_create"
