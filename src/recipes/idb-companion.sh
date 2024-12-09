#!/usr/bin/env bash

laptop::ensure_package__idb-companion() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_brew_tap "facebook/fb"
    laptop::ensure_package_default "idb-companion"
  else
    laptop::step_start "- Ensure idb-companion installed (via git)"
    laptop::step_pass
  fi
}
