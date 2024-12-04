#!/usr/bin/env bash

# Returns a list of available profile
#
# Usage:
#   laptop::profile_available
#
laptop::profile_available() {
  echo "$LAPTOP_PROFILE_DEFAULT"
  find "$LAPTOP_PROFILE_DIR" -maxdepth 1 -type f ! -name "$LAPTOP_PROFILE_DEFAULT" -exec basename {} \; | sort
}
