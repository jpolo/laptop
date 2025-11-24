#!/usr/bin/env bash

# Configure default profile (.profile, .zprofile, .zshrc, etc) using default profile templates
#
# Usage:
#   laptop_setup_default_shell
#
laptop_setup_default_shell() {
  local profile_dir
  profile_dir=$(laptop_profile_dir default)

  # Bootstrap
  laptop_file_ensure_template "$profile_dir/resource/.profile" "$HOME/.profile" --force
  laptop_shell_profile_var "LAPTOP_PROFILE" "${LAPTOP_PROFILE}"
  laptop_shell_profile_var "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

  laptop_file_ensure_template "$profile_dir/resource/.zprofile" "$HOME/.zprofile" --force
  laptop_file_ensure_template "$profile_dir/resource/.zshrc" "$HOME/.zshrc" --force
  # for backward compatibility with bash
  laptop_file_ensure_template "$profile_dir/resource/.bash_profile" "$HOME/.bash_profile" --force

  laptop_file_ensure_template "$profile_dir/resource/.zshrc.local" "$HOME/.zshrc.local"

  # Configure ZSH
  laptop_shell_exec "zsh" "$profile_dir/bootstrap-shell.zsh"
}
