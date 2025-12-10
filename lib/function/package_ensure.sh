#!/usr/bin/env bash

laptop_require "laptop_function_exists"
laptop_require "laptop_brew_ensure_package"
laptop_require "laptop_apt_ensure_package"
laptop_require "laptop_step_start_status"
laptop_require "laptop_profile_dir"
laptop_require "laptop_die"

# Install `package` if not present
#
# Usage:
#   laptop_package_ensure <package> [--status present|absent]
#
# Options:
#   --status present|absent
#
laptop_package_ensure() {
  local package="${1}"

  laptop_package_load_recipe "$package"

  # Attempt to launch a function named laptop_package_ensure__$package" if exists
  local recipe_function="laptop_package_ensure__$package"

  if laptop_function_exists "$recipe_function"; then
    $recipe_function "$@"
    return 0
  else
    # pass all arguments
    laptop_package_ensure_default "$@"
  fi
}

laptop_package_ensure_default() {
  # Install using package manager
  if [ "$LAPTOP_PACKAGE_MANAGER" = "brew" ]; then
    laptop_brew_ensure_package "$@"
  elif [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    laptop_apt_ensure_package "$@"
  else
    laptop_die "Unsupported package manager: $LAPTOP_PACKAGE_MANAGER"
  fi
}

laptop_package_load_recipe() {
  local package="${1}"
  local recipe_function="laptop_package_ensure__$package"
  if ! laptop_function_exists "$recipe_function"; then
    # try to load recipe from $LAPTOP_LIB_DIR/recipe, then profile/recipe, if file is found then check function was declared
    local recipe_path=(
      "$(laptop_profile_dir)/recipe"
      "$LAPTOP_LIB_DIR/recipe"
    )

    for recipe_dir in "${recipe_path[@]}"; do
      # replace : with _ in file name
      local recipe_file="$recipe_dir/${package//:/_}.sh"

      if [ -f "$recipe_file" ]; then
        # shellcheck disable=SC1090
        source "$recipe_file"
        if ! laptop_function_exists "$recipe_function"; then
          laptop_die "Function '$recipe_function' not found in file '$recipe_file'"
        fi
        break
      fi
    done
  fi
}

# Display a step with a target status
#
# Usage:
#   laptop_package_ensure_start <package> [--status present|absent] [--current-status present|absent]
#
# Options:
#   <current_status> present|absent
#   <target_status> present|absent
laptop_package_ensure_start() {
  local package="${1}"
  local resource_status="present"
  local current_resource_status="unknown"

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    --current-status)
      current_resource_status="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local message
  if [ "$LAPTOP_PACKAGE_MANAGER" = "apt-get" ]; then
    message="apt package '$package'"
  else
    message="$LAPTOP_PACKAGE_MANAGER package '$package'"
  fi
  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"
}
