#!/usr/bin/env bash

# Install apt `package` if not present
#
# Usage:
#   laptop_ensure_apt_package <package>
#
laptop_ensure_apt_package() {
  local package="$1"

  laptop_step_start "- Ensure apt package '$package'"
  if dpkg -s "$package" &>/dev/null; then
    laptop_step_ok
  else
    laptop_step_eval "sudo apt-get install $(quote "$package") -yy"
  fi
}
