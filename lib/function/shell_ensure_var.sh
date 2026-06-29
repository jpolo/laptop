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
#   laptop_shell_ensure_var <script_file> <var_name> <value> [--export]
#
# Options:
#   --export  Ensure the variable is written as an export assignment (default: false)
#
laptop_shell_ensure_var() {
  local script_file="$1"
  local var_name="$2"
  local value="$3"
  local use_export=0
  shift 3

  while [[ $# -gt 0 ]]; do
    case $1 in
    --export)
      use_export=1
      shift
      ;;
    *)
      echo "Unknown option $1" >&2
      return 1
      ;;
    esac
  done

  local resource_status="present"

  local current_value
  current_value=$(laptop_file_var_get "$script_file" "$var_name")

  local current_exported=0
  if .laptop_file_var_set_exported "$script_file" "$var_name"; then
    current_exported=1
  fi

  local resource_current_status="unknown"
  if [ "$current_value" = "$value" ] && [ "$current_exported" -eq "$use_export" ]; then
    resource_current_status="present"
  else
    resource_current_status="absent"
  fi

  laptop_step_start_status "$resource_status" "$resource_current_status" "Variable '$var_name=$value' in '$(laptop_path_print "$script_file")'"

  if [ "$resource_current_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      if [ -n "$value" ]; then
        if [ "$use_export" -eq 1 ]; then
          laptop_step_exec laptop_file_var_set "$script_file" "$var_name" "$value" --export
        else
          laptop_step_exec laptop_file_var_set "$script_file" "$var_name" "$value"
        fi
      else
        laptop_step_status "pass"
        laptop_log warn "$var_name is empty in '$(laptop_path_print "$script_file")'"
      fi
    else
      laptop_step_exec laptop_die "Not Implemented"
    fi
  fi
}
