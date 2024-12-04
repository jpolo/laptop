#!/usr/bin/env bash

laptop::ensure_apt_package() {
  local executable="$1"
  local package=${2:-$executable}

  laptop::step_start "- Ensure apt package '$executable'"
  if dpkg -s "$package" &>/dev/null; then
    laptop::step_ok
  else
    laptop::step_eval "sudo apt-get install $(quote $package) -yy"
  fi
}
