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

  local in_section=0
  local result=""

  # Handle anonymous section (.anon) - keys before any [section]
  if [ "$section" = ".anon" ]; then
    in_section=1
  fi

  while IFS= read -r line; do
    # Skip empty lines and comments
    [[ "$line" =~ ^[[:space:]]*$ ]] && continue
    [[ "$line" =~ ^[[:space:]]*[\#\;] ]] && continue

    # Check for section headers [section_name]
    if [[ "$line" =~ ^[[:space:]]*\[([^\]]+)\][[:space:]]*$ ]]; then
      local found_section="${BASH_REMATCH[1]}"
      if [ "$found_section" = "$section" ]; then
        in_section=1
      else
        in_section=0
      fi
      continue
    fi

    # If we're in the right section, look for the key
    if [ "$in_section" = 1 ]; then
      if [[ "$line" =~ ^[[:space:]]*${key}[[:space:]]*=[[:space:]]*(.*) ]]; then
        result="${BASH_REMATCH[1]}"
        # Remove trailing whitespace and quotes
        result=$(echo "$result" | sed 's/[[:space:]]*$//' | sed 's/^"\(.*\)"$/\1/' | sed "s/^'\(.*\)'$/\1/")
        break
      fi
    fi
  done < "$config_file"

  echo "$result"
}
