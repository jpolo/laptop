#!/usr/bin/env bash

# Test laptop_asdf_ensure_plugin
assert_raises "laptop_asdf_ensure_plugin 'nodejs' 'https://github.com/asdf-vm/asdf-nodejs.git'" 0
assert_raises "laptop_asdf_ensure_plugin 'nodejs' 'https://github.com/asdf-vm/asdf-nodejs.git'" 0

# Test laptop_asdf_ensure_package
assert_raises "laptop_asdf_ensure_package 'nodejs' 'latest:20'" 0
assert_raises "laptop_asdf_ensure_package 'nodejs' 'latest:20'" 0
