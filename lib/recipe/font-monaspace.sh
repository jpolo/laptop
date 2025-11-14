#!/usr/bin/env bash

laptop_package_ensure__font-monaspace() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # NOT required anymore
    # laptop_brew_ensure_tap "homebrew/cask-fonts"
    laptop_package_ensure_default "font-monaspace"
  else
    laptop_package_ensure_default "font-monaspace"
  fi
}
