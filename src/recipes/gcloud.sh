#!/usr/bin/env bash

laptop_ensure_package__gcloud() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_cask_package "gcloud-cli"
  else
    laptop_ensure_package_default "gcloud"
  fi
}
