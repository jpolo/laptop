#!/usr/bin/env bash

laptop::ensure_package__docker-desktop() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_brew_cask_package "docker"
  else
    laptop::ensure_package_default "docker-desktop"
  fi
}
