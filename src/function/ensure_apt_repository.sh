#!/usr/bin/env bash

laptop::ensure_apt_repository() {
  local repo_url="$1"
  local repo_key="$2"

  laptop::ensure_apt_key "$repo_key"

  laptop::step_start "- Ensure apt repository '$repo_url'"
  # Check if the repository is already added
  if grep -q "^deb .*$repo_url" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    laptop::step_ok
  else
    laptop::step_eval "echo 'deb $repo_url' | sudo tee -a /etc/apt/sources.list.d/custom.list >/dev/null && sudo apt-get update"
  fi
}
