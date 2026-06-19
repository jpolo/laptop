#!/usr/bin/env bash

laptop_require "laptop_step_start_status"
laptop_require "laptop_step_exec"
laptop_require "laptop_step_status"
laptop_require "laptop_command_exists"
laptop_require "laptop_log"

# Ensure npm config is set
#
# Usage:
#   laptop_npm_config_ensure <key> <value>
#
laptop_npm_config_ensure() {
  local key="$1"
  local value="$2"
  shift 2

  local resource_status="present"
  local location="user"
  while [[ $# -gt 0 ]]; do
    case "$1" in
    -s | --status)
      resource_status="$2"
      shift 2
      ;;
    -l | --location)
      location="$2"
      shift 2
      ;;
    *) shift ;;
    esac
  done

  local current_value
  current_value=$(npm config get "$key" --location="$location" 2>/dev/null)

  local current_resource_status
  current_resource_status=$([ "$current_value" = "$value" ] && echo "present" || echo "absent")
  local message="NPM config ${key}=${value} (location: ${location})"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if ! laptop_command_exists "npm"; then
    laptop_step_status "fail"
    laptop_log error "npm is required to manage npm config"
    return 1
  fi

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec npm config set "$key" "$value" --location="$location"
    else
      laptop_step_exec npm config delete "$key" --location="$location"
    fi
  fi
}
