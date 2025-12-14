#!/usr/bin/env bash

# Load a function if it is not already loaded
#
# Usage:
#   laptop_require <function_name>
#
laptop_require() {
  local function_name="$1"
  if ! declare -f -F "$function_name" &>/dev/null; then

    # if starts with laptop_ then use the laptop_lib_dir
    if [[ "$function_name" == laptop_* ]]; then
      # remove laptop_ prefix
      local function_name_without_laptop_prefix="${function_name#laptop_}"
      # shellcheck disable=SC1090
      source "${LAPTOP_LIB_DIR:-"$LAPTOP_HOME/lib"}/function/$function_name_without_laptop_prefix.sh"
    fi
  fi

  if ! declare -f -F "$function_name" &>/dev/null; then
    echo "Function '$function_name' is not defined"
    exit 1
  fi
}
