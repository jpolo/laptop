#!/usr/bin/env bash

laptop_require "laptop_ini_get"

# Get a value from the laptop config file.
#
# Usage:
#   laptop_self_config_get <key>
#
laptop_self_config_get() {
  local key="$1"

  laptop_ini_get "$LAPTOP_USER_CONFIG_FILE" "$key"
}
