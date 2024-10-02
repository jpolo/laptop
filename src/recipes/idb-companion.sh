#!/usr/bin/env bash

ensure_package__idb-companion() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_brew_tap "facebook/fb"
    ensure_package_default "idb-companion"
  else
    _laptop_step_start "- Ensure idb-companion installed (via git)"
    _laptop_step_pass
  fi
}
