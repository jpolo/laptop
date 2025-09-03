#!/usr/bin/env bash

laptop::ensure_ssh_directory() {
  local ssh_dir
  ssh_dir="$HOME/.ssh"

  laptop::step_start "- Ensure SSH directory '$ssh_dir'"
  laptop::step_eval "mkdir -p \"$ssh_dir\" && chmod 0700 \"$ssh_dir\""

  laptop::step_start "- Ensure SSH config '$ssh_dir/config'"
  laptop::step_eval "touch \"$ssh_dir/config\" && chmod 0600 \"$ssh_dir/config\""
}
