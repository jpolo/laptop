#!/usr/bin/env bash

# Configure default profile (.profile, .zprofile, .zshrc, etc) using default profile templates
#
# Usage:
#   laptop::configure_default_shell
#
laptop::configure_default_shell() {
  local profile_dir
  profile_dir=$(laptop::profile_dir default)

  # Bootstrap
  laptop::bootstrap
  laptop::ensure_file_template "$profile_dir/resource/.profile" "$HOME/.profile"
  laptop::set_user_profile "LAPTOP_PROFILE" "${LAPTOP_PROFILE}"
  laptop::set_user_profile "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

  laptop::ensure_file_template "$profile_dir/resource/.zprofile" "$HOME/.zprofile"
  laptop::ensure_file_template "$profile_dir/resource/.zshrc" "$HOME/.zshrc"
  # for backward compatibility with bash
  laptop::ensure_file_template "$profile_dir/resource/.bash_profile" "$HOME/.bash_profile"

  if [ ! -f "$HOME/.zshrc.local" ];then
    laptop::ensure_file_template "$LAPTOP_PROFILE_DEFAULT_DIR/resource/zshrc.local" "$HOME/.zshrc.local"
  fi
}
