#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure sdkmanager is up to date
#
# Usage:
#   laptop_sdkmanager_ensure_updated
#
laptop_sdkmanager_ensure_updated() {
  laptop_step_upgrade_start "sdkmanager updated"
  laptop_step_eval "yes | sdkmanager --licenses && sdkmanager --update"
}
