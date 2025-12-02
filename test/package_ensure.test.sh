#!/usr/bin/env bash

# Try to run brew installation
laptop_package_ensure "brew"

# Test laptop_package_ensure
laptop_package_ensure "asdf"
laptop_package_ensure "asdf"
