#!/usr/bin/env bash

laptop_package_ensure() {
  local executable="$1"
  local package="${2:-$executable}"

  # Attempt to launch a function named laptop_package_ensure__$package" if exists
  local recipe_function="laptop_package_ensure__$package"

  if laptop_function_exists "$recipe_function"; then
    $recipe_function
    return 0
  else
    laptop_package_ensure_default "$executable" "$package"
  fi
}

laptop_package_ensure_default() {
  local executable="$1"
  local package=${2:-$executable}

  # Install using package manager
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "$executable" "$package"
  elif [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    laptop_apt_ensure_package "$executable" "$package"
  else
    laptop_step_fail
  fi
}
