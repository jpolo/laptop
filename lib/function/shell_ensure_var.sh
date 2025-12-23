#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_eval"
laptop_require "laptop_step_status"
laptop_require "laptop_log"
laptop_require "laptop_path_print"
laptop_require "laptop_file_var_set"
laptop_require "laptop_file_var_get"

#
# Add or Update variable expression in script file
#
# Usage:
#   laptop_shell_ensure_var <script_file> <var_name> <value>
#
laptop_shell_ensure_var() {
  local script_file="$1"
  local var_name="$2"
  local value="$3"

  local resource_status="present"

  local current_value
  current_value=$(laptop_file_var_get "$script_file" "$var_name")

  local resource_current_status="unknown"
  resource_current_status=$([ "$current_value" = "$value" ] && echo "present" || echo "absent")

  laptop_step_start_status "$resource_status" "$resource_current_status" "Variable '$var_name=$value' in '$(laptop_path_print "$script_file")'"

  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      if [ -n "$value" ]; then
        laptop_step_exec laptop_file_var_set "$script_file" "$var_name" "$value"
      else
        laptop_step_status "pass"
        laptop_log warn "$var_name is empty in '$(laptop_path_print "$script_file")'"
      fi
    else
      laptop_step_exec laptop_die "Not Implemented"
    fi
  fi
}
