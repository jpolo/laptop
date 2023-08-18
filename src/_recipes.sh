#!/usr/bin/env bash

ensure_package__libpq() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "libpq"
  else
    ensure_package_default "libpq-dev"
  fi
}


ensure_package__libyaml() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "libyaml"
  else
    ensure_package_default "libyaml-dev"
  fi
}

ensure_package__libvips() {
  if [ $LAPTOP_PACKAGE_MANAGER = "brew" ];then
    ensure_package_default "vips"
  else
    ensure_package_default "libvips-dev"
  fi
}
