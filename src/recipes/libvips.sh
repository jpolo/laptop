#!/usr/bin/env bash

laptop::ensure_package__libvips() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    laptop::ensure_package_default "vips"
  else
    laptop::ensure_package_default "libvips-dev"
  fi
}
