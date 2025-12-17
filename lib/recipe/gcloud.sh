#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_package_ensure_default"

laptop_package_ensure__gcloud() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "gcloud-cli" --cask
  else
    laptop_package_ensure_default "gcloud"
  fi
}
