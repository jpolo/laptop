#!/usr/bin/env bash

# Get INI file values
#
# Usage:
#   laptop_ini_get <config_file> <key>
#
laptop_ini_get() {
  local config_file="$1"
  local key="$2"

  if [ ! -f "$config_file" ]; then
    echo ""
    return
  fi

  local result
  result=$(augtool -A <<EOF
set /augeas/load/IniFile/lens IniFile.lns_loose
set /augeas/load/IniFile/incl "$config_file"
load
print /files$config_file/section/$key
EOF
)
  echo "$result"| sed -n 's/.* = "\(.*\)"/\1/p'

}
