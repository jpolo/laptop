#!/usr/bin/env bash

laptop_require "laptop_profile_dir"
laptop_require "laptop_shell_exec_dir_d"

# Run every steps in alphabetic order (in a separate shell instance)
#
# Usage:
#   laptop_setup_steps <steps_dir>
#
laptop_setup_steps() {
  local steps_dir
  steps_dir=${1:-"$(laptop_profile_dir)/steps"}
  LAPTOP_SOURCE_ALL=true laptop_shell_exec_dir_d "$steps_dir"
}
