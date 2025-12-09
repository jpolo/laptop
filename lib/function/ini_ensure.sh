#!/usr/bin/env bash

# Set INI file values
#
# Usage:
#   laptop_ini_ensure <file> <key> <value>
#
laptop_ini_ensure() {
  local file="$1"
  local section=".anon"
  local key="$2"
  local value="$3"

  # split section if key contains a dot
  if [[ "$key" == *.* ]]; then
    section=$(echo "$key" | cut -d'.' -f1)
    key=$(echo "$key" | cut -d'.' -f2)
  fi

  local current_value
  current_value=$(laptop_ini_get "$file" "$2")
  local resource_status="present"
  local current_resource_status
  current_resource_status=$([ "$current_value" = "$value" ] && echo "present" || echo "absent")

  local resource_status="present"
  local current_resource_status

  local message
  message="INI setting $2=$value"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_ok
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec augtool -A <<EOF
set /augeas/load/IniFile/lens IniFile.lns_loose
set /augeas/load/IniFile/incl '$file'
load
set "/files/$file/section[.=$(quote "$section")]" $(quote "$section")
set "/files/$file/section[.=$(quote "$section")]/${key}" $(quote "$value")
save
EOF
    else
      laptop_step_fail
      laptop_error "Not implemented"
    fi
  fi
}






