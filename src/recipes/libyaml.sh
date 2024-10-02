#!/usr/bin/env bash

laptop::ensure_package__libyaml() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    laptop::ensure_package_default "libyaml"
  else
    laptop::ensure_package_default "libyaml-dev"
  fi
}
