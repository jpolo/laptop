#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure npm packages are up to date
#
# Usage:
#   laptop_npm_ensure_updated
#
laptop_npm_ensure_updated() {
  laptop_step_upgrade_start "npm updated"
  laptop_step_eval "npm update -g"
}
