#!/usr/bin/env bash

# Try to run brew installation
assert_raises "command -v brew" 1
assert_raises "laptop_package_ensure 'brew'" 0
assert_raises "command -v brew" 0

# Test laptop_package_ensure
assert_raises "command -v asdf" 1
assert_raises "laptop_package_ensure 'asdf'" 0
assert_raises "command -v asdf" 0
assert_raises "laptop_package_ensure 'asdf'" 0
