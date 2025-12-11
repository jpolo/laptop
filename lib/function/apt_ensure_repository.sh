#!/usr/bin/env bash

laptop_require "laptop_apt_ensure_key"
laptop_require "laptop_step_start"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"

# Add `repo_url` as an apt repository url using `repo_key`
#
# Usage:
#   laptop_apt_ensure_package <repo_url> <repo_key>
#
laptop_apt_ensure_repository() {
  local repo_url="$1"
  local repo_key="$2"

  laptop_apt_ensure_key "$repo_key"

  laptop_step_start "- Ensure apt repository '$repo_url'"
  # Check if the repository is already added
  if grep -q "^deb .*$repo_url" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    laptop_step_status "ok"
  else
    laptop_step_eval "echo 'deb $repo_url' | sudo tee -a /etc/apt/sources.list.d/custom.list >/dev/null && sudo apt-get update"
  fi
}
