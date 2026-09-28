#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure androidsdk is up to date
#
# Usage:
#   laptop_androidsdk_ensure_updated
#
laptop_androidsdk_ensure_updated() {
  laptop_step_upgrade_start "android sdk updated"
  laptop_step_eval "yes | android sdk update"
}
