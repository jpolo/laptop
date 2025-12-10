#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure asdf packages are up to date
#
# Usage:
#   laptop_asdf_ensure_updated
#
laptop_asdf_ensure_updated() {
  laptop_step_upgrade_start "asdf updated"
  laptop_step_eval "asdf plugin update --all"
}
