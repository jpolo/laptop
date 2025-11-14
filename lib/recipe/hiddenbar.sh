#!/usr/bin/env bash

laptop_package_ensure__hiddenbar() {
  local package="hiddenbar"

  # Install hidden bar on mac only, else mark step as pass
  if [[ "$OSTYPE" == "darwin"* ]]; then
    laptop_brew_ensure_package "$package"
  else
    laptop_package_ensure_start "$package" --status "unknown"
    laptop_step_pass
  fi
}

