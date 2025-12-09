#!/usr/bin/env bash

# Configure XDG desktop directories compatibility
#
# Usage:
#   laptop_setup_xdg_desktop
#
laptop_setup_xdg_desktop() {
  local profile_dir
  profile_dir=$(laptop_profile_dir default)

  laptop_file_ensure_template "$profile_dir/resource/.profile" "$HOME/.profile" --force
  laptop_file_ensure_template "$profile_dir/resource/.zprofile" "$HOME/.zprofile" --force
  # for backward compatibility with bash
  laptop_file_ensure_template "$profile_dir/resource/.bash_profile" "$HOME/.bash_profile" --force
}
