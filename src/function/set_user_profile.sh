#!/usr/bin/env bash

#
# Add or Update variable expression in ~/.profile
#
# Usage:
#   laptop::set_user_profile <var_name> <value>
#
laptop::set_user_profile() {
  local script_file="$HOME/.profile"
  local var_name="$1"
  local value="$2"
  laptop::step_start "- Set '$var_name=$value' in '$script_file'"

  if [ ! -z "$value" ]; then
    laptop::var_in_file "$script_file" "$var_name" "$value"
    laptop::step_ok
  else
    laptop::step_pass
    laptop::warn "$var_name is empty"
  fi
}
