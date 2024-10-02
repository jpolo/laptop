#!/usr/bin/env bash

ensure_package__font-monaspace() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    # NOT required anymore
    # ensure_brew_tap "homebrew/cask-fonts"
    ensure_package_default "font-monaspace"
  else
    ensure_package_default "font-monaspace"
  fi
}
