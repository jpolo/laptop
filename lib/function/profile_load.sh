#!/usr/bin/env bash

laptop_require "laptop_die"

# Load profile using $LAPTOP_PROFILE
#
# Usage:
#   laptop_profile_load
#
laptop_profile_load() {
  local profile_file="$LAPTOP_PROFILE_DIR/$LAPTOP_PROFILE/profile.sh"
  if [ ! -f "$profile_file" ]; then
    laptop_die "Profile \"$LAPTOP_PROFILE\" does not exist"
  fi
  # shellcheck disable=SC1090
  source "$profile_file"
}
