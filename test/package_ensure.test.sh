#!/usr/bin/env bash

# Try to run brew installation
assert_raises "laptop_package_ensure 'brew'" 0
assert_raises "command -v brew" 0

# Test laptop_package_ensure
assert_raises "laptop_package_ensure 'asdf'" 0
assert_raises "command -v asdf" 0
assert_raises "laptop_package_ensure 'asdf'" 0

# Test laptop_asdf_ensure_plugin
assert_raises "laptop_asdf_ensure_plugin 'nodejs' 'https://github.com/asdf-vm/asdf-nodejs.git'" 0
assert_raises "laptop_asdf_ensure_plugin 'nodejs' 'https://github.com/asdf-vm/asdf-nodejs.git'" 0

# Test laptop_asdf_ensure_package
assert_raises "laptop_asdf_ensure_package 'nodejs' 'latest:20'" 0
assert_raises "laptop_asdf_ensure_package 'nodejs' 'latest:20'" 0
