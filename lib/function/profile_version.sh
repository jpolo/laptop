#!/usr/bin/env bash

laptop_require "laptop_self_version"

# Returns the laptop profile version.
#
# Currently this is the laptop CLI version. Later it may become a semantic
# version of the profile and its functions.
#
# Usage:
#   laptop_profile_version
#
laptop_profile_version() {
  # TODO: This is a temporary solution to get the profile version.
  # Later we should use the profile version from the profile file.
  laptop_self_version
}
