#!/usr/bin/env bash

# Returns the location for the profile passed as parameter
#
# Usage:
#   laptop_profile_dir <profile_name>
#
laptop_profile_dir() {
  echo "$LAPTOP_PROFILE_DIR/${1:-$LAPTOP_PROFILE}"
}
