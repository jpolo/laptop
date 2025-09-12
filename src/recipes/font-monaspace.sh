#!/usr/bin/env bash

laptop_ensure_package__font-monaspace() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    # NOT required anymore
    # laptop_ensure_brew_tap "homebrew/cask-fonts"
    laptop_ensure_package_default "font-monaspace"
  else
    laptop_ensure_package_default "font-monaspace"
  fi
}
