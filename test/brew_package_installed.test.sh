#!/usr/bin/env bash

laptop_require "laptop_brew_package_installed"
laptop_require "laptop_brew_package_version"
laptop_require "laptop_self_version"

mock_prefix="$TEST_TMP_DIR/homebrew"
mkdir -p "$mock_prefix/Cellar/laptop/1.2.3"

# laptop_brew_package_installed uses filesystem check
assert_raises "HOMEBREW_PREFIX='$mock_prefix' laptop_brew_package_installed 'Inthememory/tap/laptop'" 0
assert_raises "HOMEBREW_PREFIX='$mock_prefix' laptop_brew_package_installed 'missing/package'" 1

# laptop_brew_package_version reads the cellar version directory
assert "HOMEBREW_PREFIX='$mock_prefix' laptop_brew_package_version 'Inthememory/tap/laptop'" "1.2.3"

# laptop_self_version prefers git when LAPTOP_HOME is a git repo
assert "laptop_self_version" "$(laptop_self_version)"
