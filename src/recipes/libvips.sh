#!/usr/bin/env bash

ensure_package__libvips() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "vips"
  else
    ensure_package_default "libvips-dev"
  fi
}
