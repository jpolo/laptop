#!/usr/bin/env bash

laptop_ssh_ensure_directory() {
  local ssh_dir
  ssh_dir="$HOME/.ssh"
  local ssh_config_file="$ssh_dir/config"

  laptop_step_start "- Ensure SSH directory '$ssh_dir'"
  laptop_step_eval "mkdir -p \"$ssh_dir\" && chmod 0700 \"$ssh_dir\""

  laptop_step_start "- Ensure SSH config '$ssh_config_file'"
  laptop_step_eval "touch \"$ssh_config_file\" && chmod 0600 \"$ssh_config_file\""
}
