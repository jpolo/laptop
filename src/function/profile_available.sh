#!/usr/bin/env bash

# Returns a list of available profile
#
# Usage:
#   laptop::profile_available
#
laptop::profile_available() {
  echo "$LAPTOP_PROFILE_DEFAULT"
  ls "$LAPTOP_PROFILE_DIR" | grep -v "$LAPTOP_PROFILE_DEFAULT" | sort
}
