#!/usr/bin/env bash

laptop_ensure_package__libvips() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_package_default "vips"
  else
    laptop_ensure_package_default "libvips-dev"
  fi
}
