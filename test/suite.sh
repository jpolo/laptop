#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1
LAPTOP_HOME=$(pwd)
export LAPTOP_HOME
source "./src/env.sh"

mkdir -p "test_data"
cd "test_data" || exit 1

# Try to run brew installation
laptop_ensure_package "brew"

# Test laptop_ensure_package
laptop_ensure_package "asdf"
laptop_ensure_package "asdf"

# Test laptop_ensure_asdf_plugin
laptop_ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
laptop_ensure_asdf_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test laptop_ensure_asdf_package
laptop_ensure_asdf_package "nodejs" "latest:20"
laptop_ensure_asdf_package "nodejs" "latest:20"

# Test laptop_ensure_directory
laptop_ensure_directory "./folder_create/"
laptop_ensure_directory "./folder_create/"

# Test laptop_ensure_file
laptop_ensure_file "./test_file_create"
laptop_ensure_file "./test_file_create"
