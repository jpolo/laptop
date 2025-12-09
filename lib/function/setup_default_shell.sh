#!/usr/bin/env bash

# Configure default profile (.profile, .zprofile, .zshrc, etc) using default profile templates
#
# Usage:
#   laptop_setup_default_shell
#
laptop_setup_default_shell() {
  local profile_dir
  profile_dir=$(laptop_profile_dir default)

  # Ensure profile is set
  if [ -z "$(laptop_ini_get "$LAPTOP_USER_CONFIG_FILE" "profile")" ]; then
    if [ -z "$LAPTOP_PROFILE" ]; then
      laptop_die "LAPTOP_PROFILE is not set"
    fi
    laptop_file_ensure "$LAPTOP_USER_CONFIG_FILE"
    laptop_ini_ensure "$LAPTOP_USER_CONFIG_FILE" "profile" "$LAPTOP_PROFILE"
  fi

  laptop_shell_profile_var "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

  laptop_file_ensure_template "$profile_dir/resource/.zshrc" "$HOME/.zshrc" --force
  laptop_file_ensure_template "$profile_dir/resource/.zshrc.local" "$HOME/.zshrc.local"

  # Configure ZSH
  laptop_shell_exec "zsh" "$profile_dir/bootstrap-shell.zsh"
}
