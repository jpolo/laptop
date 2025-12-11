#!/usr/bin/env bash

laptop_package_ensure__container() {
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    if [[ "$OSTYPE" == "darwin"* ]]; then
      laptop_brew_ensure_cask_package "container" "${@:2}"
    else
      laptop_step_resource_start_status "$@"
      laptop_step_status "pass"
    fi
  else
    laptop_step_resource_start_status "$@"
    laptop_step_status "pass"
  fi
}
