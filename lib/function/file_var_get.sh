#!/usr/bin/env bash

# Get a variable from a shell script file.
#
# Usage:
#   laptop_file_var_get "my_shell.sh" "MY_VARIABLE"
#
laptop_file_var_get() {
  local script_file="$1"
  local var_name="$2"
  grep -E "^[[:blank:]]*export[[:blank:]]*${var_name}=[^[:blank:]]*" "$script_file" | cut -d'=' -f2
}
