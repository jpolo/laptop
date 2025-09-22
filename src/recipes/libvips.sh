#!/usr/bin/env bash

laptop_package_ensure__libvips() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_package_ensure_default "vips"
  else
    laptop_package_ensure_default "libvips-dev"
  fi
}
