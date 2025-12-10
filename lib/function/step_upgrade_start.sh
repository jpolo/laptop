#!/usr/bin/env bash

laptop_require "laptop_step_start"

# Display a step with a upgrade status
#
# Usage:
#   laptop_step_upgrade_start <message>
#
laptop_step_upgrade_start() {
  laptop_step_start "${COLOR_SUCCESS}↻${NORMAL} $1"
}
