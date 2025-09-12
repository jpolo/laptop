#!/usr/bin/env bash

laptop_ensure_package__idb-companion() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_tap "facebook/fb"
    laptop_ensure_package_default "idb-companion"
  else
    laptop_step_start "- Ensure idb-companion installed (via git)"
    laptop_step_pass
  fi
}
