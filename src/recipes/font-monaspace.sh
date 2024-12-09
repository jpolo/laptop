#!/usr/bin/env bash

laptop::ensure_package__font-monaspace() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # NOT required anymore
    # laptop::ensure_brew_tap "homebrew/cask-fonts"
    laptop::ensure_package_default "font-monaspace"
  else
    laptop::ensure_package_default "font-monaspace"
  fi
}
