#!/usr/bin/env bash

laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_step_resource_start_status"
laptop_require "laptop_step_status"

laptop_package_ensure__hiddenbar() {
  local package="hiddenbar"

  # Install hidden bar on mac only, else mark step as pass
  if [[ "$OSTYPE" == "darwin"* ]]; then
    laptop_brew_ensure_package "$package" "$@"
  else
    laptop_step_resource_start_status "$package" --status "unknown"
    laptop_step_status "pass"
  fi
}
