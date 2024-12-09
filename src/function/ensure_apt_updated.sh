#!/usr/bin/env bash

laptop::ensure_apt_updated() {
  laptop::step_start "- Ensure APT updated"
  # shellcheck disable=SC2012
  if [ ! -d "/var/lib/apt/lists" ] || [ "$(ls /var/lib/apt/lists/ | wc -l)" = "0" ]; then
    laptop::step_exec sudo apt-get update
  else
    laptop::step_ok
  fi
}
