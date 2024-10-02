#!/usr/bin/env bash

ensure_package__libyaml() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ];then
    ensure_package_default "libyaml"
  else
    ensure_package_default "libyaml-dev"
  fi
}
