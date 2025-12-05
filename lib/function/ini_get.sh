#!/usr/bin/env bash

# Get INI file values
#
# Usage:
#   laptop_ini_get <config_file> <key>
#
laptop_ini_get() {
  local config_file="$1"
  local section=".anon"
  local key="$2"

  if [ ! -f "$config_file" ]; then
    echo ""
    return
  fi

  # split section if key contains a dot
  if [[ "$key" == *.* ]]; then
    section=$(echo "$key" | cut -d'.' -f1)
    key=$(echo "$key" | cut -d'.' -f2)
  fi

  local result
  result=$(
    augtool -A <<EOF
set /augeas/load/IniFile/lens IniFile.lns_loose
set /augeas/load/IniFile/incl "$config_file"
load
get /files$config_file/section[.="$section"]/$key
EOF
  )
  # extract the part after = and remove starting space
  echo "$result" | sed -n 's/.* = \(.*\)/\1/p'
}
