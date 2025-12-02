#!/usr/bin/env bash

# Test laptop_asdf_ensure_plugin
laptop_asdf_ensure_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"
laptop_asdf_ensure_plugin "nodejs" "https://github.com/asdf-vm/asdf-nodejs.git"

# Test laptop_asdf_ensure_package
laptop_asdf_ensure_package "nodejs" "latest:20"
laptop_asdf_ensure_package "nodejs" "latest:20"
