#!/usr/bin/env bash

laptop_require "laptop_function_exists"
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

  laptop_package_load_definition "$package"

  # Attempt to launch a function named laptop_package_ensure__$package" if exists
  local definition_function="laptop_package_ensure__$package"

  if laptop_function_exists "$definition_function"; then
    $definition_function "$@"
    return 0
  else
    # pass all arguments
    laptop_package_ensure_default "$@"
  fi
}

laptop_package_load_definition() {
  local package="${1}"
  local definition_function="laptop_package_ensure__$package"
  if ! laptop_function_exists "$definition_function"; then
    # try to load recipe from $LAPTOP_LIB_DIR/package, then profile/package, if file is found then check function was declared
    local definition_path=(
      "$(laptop_profile_dir)/package"
      "$LAPTOP_LIB_DIR/package"
    )

    for definition_dir in "${definition_path[@]}"; do
      # replace : with _ in file name
      local definition_file="$definition_dir/${package//:/_}.sh"

      if [ -f "$definition_file" ]; then
        # shellcheck disable=SC1090
        source "$definition_file"
        if ! laptop_function_exists "$definition_function"; then
          laptop_die "Function '$definition_function' not found in file '$definition_file'"
        fi
        break
      fi
    done
  fi
}
