#!/usr/bin/env bash

laptop::ensure_package__gcloud() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop::ensure_package_default "gcloud-cli"
  else
    laptop::ensure_package_default "gcloud"
  fi
}
