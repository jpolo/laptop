#!/usr/bin/env bash

#
# Usage:
#   laptop::var_in_file "my_shell.sh" "MY_VARIABLE" "MY_VALUE"
#
laptop::var_in_file() {
  local script_file="$1"
  local var_name="$2"
  local new_value="$3"

  # Check if the variable is already set in the script
  if grep -qE "^[[:blank:]]*export[[:blank:]]*${var_name}=[^[:blank:]]*" "$script_file"; then
    # Update the value if it's already set
    sed -i "s/^export ${var_name}=.*/export ${var_name}=${new_value}/" "$script_file"
  else
    # Append the new assignment if not set
    echo "export ${var_name}=${new_value}" >>"$script_file"
  fi
}
