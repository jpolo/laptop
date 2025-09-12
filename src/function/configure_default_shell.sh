#!/usr/bin/env bash

# Configure default profile (.profile, .zprofile, .zshrc, etc) using default profile templates
#
# Usage:
#   laptop_configure_default_shell
#
laptop_configure_default_shell() {
  local profile_dir
  profile_dir=$(laptop_profile_dir default)

  # Bootstrap
  laptop_ensure_file_template "$profile_dir/resource/.profile" "$HOME/.profile" --force
  laptop_set_user_profile "LAPTOP_PROFILE" "${LAPTOP_PROFILE}"
  laptop_set_user_profile "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

  laptop_ensure_file_template "$profile_dir/resource/.zprofile" "$HOME/.zprofile" --force
  laptop_ensure_file_template "$profile_dir/resource/.zshrc" "$HOME/.zshrc" --force
  # for backward compatibility with bash
  laptop_ensure_file_template "$profile_dir/resource/.bash_profile" "$HOME/.bash_profile" --force

  laptop_ensure_file_template "$profile_dir/resource/.zshrc.local" "$HOME/.zshrc.local"
}
