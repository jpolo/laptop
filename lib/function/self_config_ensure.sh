#!/usr/bin/env bash

laptop_require "laptop_file_ensure"
laptop_require "laptop_ini_ensure"

# Set a value in the laptop config file.
#
# Usage:
#   laptop_self_config_ensure <key> <value>
#
laptop_self_config_ensure() {
  local key="$1"
  local value="$2"

  laptop_file_ensure "$LAPTOP_USER_CONFIG_FILE"
  laptop_ini_ensure "$LAPTOP_USER_CONFIG_FILE" "$key" "$value"
}
