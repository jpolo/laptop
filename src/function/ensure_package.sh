#!/usr/bin/env bash

laptop_ensure_package() {
  local executable="$1"
  local package="${2:-$executable}"

  # Attempt to launch a function named laptop_ensure_package__$package" if exists
  local recipe_function="laptop_ensure_package__$package"

  if laptop_function_exists "$recipe_function"; then
    $recipe_function
    return 0
  else
    laptop_ensure_package_default "$executable" "$package"
  fi
}

laptop_ensure_package_default() {
  local executable="$1"
  local package=${2:-$executable}

  # Install using package manager
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_ensure_brew_package "$executable" "$package"
  elif [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    laptop_ensure_apt_package "$executable" "$package"
  else
    laptop_step_fail
  fi
}
