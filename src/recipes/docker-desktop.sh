#!/usr/bin/env bash

laptop_package_ensure__docker-desktop() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_cask_package "docker"
  else
    laptop_package_ensure_default "docker-desktop"
  fi
}
