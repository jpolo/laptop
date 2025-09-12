#!/usr/bin/env bash

laptop_ensure_package__docker-desktop() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_cask_package "docker"
  else
    laptop_ensure_package_default "docker-desktop"
  fi
}
