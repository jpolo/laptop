#!/usr/bin/env bash

# load profile_dir.sh
# shellcheck disable=SC1091
source "${LAPTOP_LIB_DIR:-"$LAPTOP_HOME/lib"}/function/profile_dir.sh"

# Load a function if it is not already loaded
#
# Usage:
#   laptop_require <function_name>
#
laptop_require() {
  local function_name="$1"
  if ! declare -f -F "$function_name" &>/dev/null; then
    # if starts with laptop_ then use the laptop_lib_dir

    # remove laptop_ prefix
    local function_name_without_laptop_prefix="${function_name#laptop_}"
    local function_path=(
      "$(laptop_profile_dir)/function"
      "${LAPTOP_LIB_DIR:-"$LAPTOP_HOME/lib"}/function"
    )
    for function_dir in "${function_path[@]}"; do
      if [ -f "$function_dir/$function_name.sh" ]; then
        # shellcheck disable=SC1090
        source "$function_dir/$function_name.sh"
        break
      fi
      if [ -f "$function_dir/$function_name_without_laptop_prefix.sh" ]; then
        # shellcheck disable=SC1090
        source "$function_dir/$function_name_without_laptop_prefix.sh"
        break
      fi
    done
  fi

  if ! declare -f -F "$function_name" &>/dev/null; then
    echo "Function '$function_name' is not defined"
    exit 1
  fi
}
