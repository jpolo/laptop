#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"
laptop_require "laptop_log"
laptop_require "laptop_path_print"
laptop_require "laptop_file_var"

#
# Add or Update variable expression in ~/.profile
#
# Usage:
#   laptop_shell_profile_var <var_name> <value>
#
laptop_shell_profile_var() {
  local script_file="$HOME/.profile"
  local var_name="$1"
  local value="$2"
  laptop_step_start_status "present" "unknown" "Variable '$var_name=$value' in '$(laptop_path_print "$script_file")'"

  if [ -n "$value" ]; then
    laptop_file_var "$script_file" "$var_name" "$value"
    laptop_step_status "ok"
  else
    laptop_step_status "pass"
    laptop_log warn "$var_name is empty"
  fi
}
