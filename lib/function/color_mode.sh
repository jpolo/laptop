#!/usr/bin/env bash

laptop_require "laptop_die"
laptop_require "laptop_ansi"

# Set the color mode
#
# Usage:
#   laptop_color_mode <mode>
#
# Mode :
#   - auto: use ANSI colors if available
#   - always: use ANSI colors
#   - never: do not use ANSI colors
laptop_color_mode() {
  local mode="$1"
  if [ "$mode" = "auto" ]; then
    if [ -t 1 ]; then
      export LAPTOP_COLOR=true
    else
      export LAPTOP_COLOR=false
    fi
  elif [ "$mode" = "always" ]; then
    export LAPTOP_COLOR=true
  elif [ "$mode" = "never" ]; then
    export LAPTOP_COLOR=false
  else
    laptop_die "Invalid color mode: $mode"
  fi

  # Override with $NO_COLOR environment variable
  if [ ! -z "$NO_COLOR" ]; then
    export LAPTOP_COLOR=false
  fi


  # shellcheck disable=SC2034,SC2155
  export NORMAL="$(laptop_ansi reset)"
  # shellcheck disable=SC2034,SC2155
  export DIM="$(laptop_ansi dim)"
}
