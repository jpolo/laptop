#!/usr/bin/env bash

# Returns a list of available profile
#
# Usage:
#   laptop_profile_available
#
laptop_profile_available() {
  echo "$LAPTOP_PROFILE_DEFAULT"
  # shellcheck disable=SC2038
  find "$LAPTOP_PROFILE_DIR" -maxdepth 2 -type f -name "profile.sh" -exec dirname {} \; |
    xargs -I {} basename {} |
    grep -v "^default" |
    sort
}
