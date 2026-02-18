#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_step_start"
laptop_require "laptop_step_status"

laptop_package_ensure__idb-companion() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "facebook/fb/idb-companion" "$@"
  else
    laptop_step_start "- Ensure idb-companion installed (via git)"
    laptop_step_status "pass"
  fi
}
