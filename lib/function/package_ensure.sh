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
