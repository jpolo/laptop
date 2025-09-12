#!/usr/bin/env bash

#
# Add or Update variable expression in ~/.profile
#
# Usage:
#   laptop_set_user_profile <var_name> <value>
#
laptop_set_user_profile() {
  local script_file="$HOME/.profile"
  local var_name="$1"
  local value="$2"
  laptop_step_start "- Set '$var_name=$value' in '$script_file'"

  if [ -n "$value" ]; then
    laptop_var_in_file "$script_file" "$var_name" "$value"
    laptop_step_ok
  else
    laptop_step_pass
    laptop_warn "$var_name is empty"
  fi
}
