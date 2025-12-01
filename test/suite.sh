#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"

# Source assert.sh
source "$SCRIPT_DIR/env.sh"

echo "Running tests in temporary directory: $TMPDIR"

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
laptop_directory_ensure "$TMPDIR/folder_create/"
laptop_directory_ensure "$TMPDIR/folder_create/"

# Test laptop_file_ensure
laptop_file_ensure "$TMPDIR/test_file_create"
laptop_file_ensure "$TMPDIR/test_file_create"


assert_end
