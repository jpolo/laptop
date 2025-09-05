#!/usr/bin/env bash

# Install apt `package` if not present
#
# Usage:
#   laptop::ensure_apt_package <package>
#
laptop::ensure_apt_package() {
  local package="$1"

  laptop::step_start "- Ensure apt package '$package'"
  if dpkg -s "$package" &>/dev/null; then
    laptop::step_ok
  else
    laptop::step_eval "sudo apt-get install $(quote "$package") -yy"
  fi
}
