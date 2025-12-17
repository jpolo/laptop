#!/usr/bin/env bash

laptop_require "laptop_step_resource_start_status"
laptop_require "laptop_step_status"
laptop_require "laptop_brew_ensure_package"

laptop_package_ensure__container() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      laptop_brew_ensure_package "container" "${@:2}" --cask
    else
      laptop_step_resource_start_status "$@"
      laptop_step_status "pass"
    fi
  else
    laptop_step_resource_start_status "$@"
    laptop_step_status "pass"
  fi
}
