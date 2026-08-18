#!/usr/bin/env bash

laptop_require "laptop_step_upgrade_start"
laptop_require "laptop_step_eval"

# Ensure Zinit is up to date
#
# Usage:
#   laptop_zinit_ensure_updated
#
#
laptop_zimfw_ensure_updated() {
  laptop_step_upgrade_start "zimfw updated"
  laptop_step_eval "env zsh --login -i -c \"zimfw update\""
}
