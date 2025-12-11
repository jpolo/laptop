#!/usr/bin/env bash

laptop_require "laptop_profile_dir"
laptop_require "laptop_file_ensure_template"
laptop_require "laptop_shell_profile_var"
laptop_require "laptop_shell_exec"

# Configure default profile (.profile, .zprofile, .zshrc, etc) using default profile templates
#
# Usage:
#   laptop_setup_default_shell
#
laptop_setup_default_shell() {
  local profile_dir
  profile_dir=$(laptop_profile_dir default)

  laptop_shell_profile_var "LAPTOP_GIT_REMOTE" "${LAPTOP_GIT_REMOTE}"

  laptop_file_ensure_template "$profile_dir/resource/.zshrc" "$HOME/.zshrc" --force
  laptop_file_ensure_template "$profile_dir/resource/.zshrc.local" "$HOME/.zshrc.local"

  # Configure ZSH
  laptop_shell_exec "zsh" "$profile_dir/bootstrap-shell.zsh"
}
