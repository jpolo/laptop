#!/usr/bin/env bash

laptop_require "laptop_step_start"
laptop_require "laptop_color_intent"
laptop_require "laptop_ansi"

# Display a step with a upgrade status
#
# Usage:
#   laptop_step_upgrade_start <message>
#
laptop_step_upgrade_start() {
  laptop_step_start "$(laptop_ansi bold)$(laptop_color_intent success)↻$(laptop_ansi reset) $1"
}
