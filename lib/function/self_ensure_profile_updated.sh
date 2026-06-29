#!/usr/bin/env bash

laptop_require "laptop_self_ensure_updated"

# Ensure laptop library and profile files are up to date before running profile steps
#
# Usage:
#   laptop_self_ensure_profile_updated
#
laptop_self_ensure_profile_updated() {
  laptop_self_ensure_updated
}
