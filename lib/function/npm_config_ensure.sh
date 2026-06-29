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

  if ! laptop_command_exists "npm"; then
    laptop_step_status "fail"
    laptop_log error "npm is required to manage npm config"
    return 1
  fi

  local config_file line current_value=""
  if [ -n "${npm_config_userconfig:-}" ]; then
    config_file="$npm_config_userconfig"
  else
    config_file=$(npm config get userconfig --location="$location" 2>/dev/null)
  fi

  if [ -f "$config_file" ]; then
    line=$(grep -F "${key}=" "$config_file" 2>/dev/null | head -1)
    [ -n "$line" ] && current_value="${line#"${key}="}"
  fi

  local current_resource_status
  current_resource_status=$([ "$current_value" = "$value" ] && echo "present" || echo "absent")
  local message="NPM config ${key}=${value} (location: ${location})"

  laptop_step_start_status "$resource_status" "$current_resource_status" "$message"

  if [ "$current_resource_status" = "$resource_status" ]; then
    laptop_step_status "ok"
  else
    if [ "$resource_status" = "present" ]; then
      laptop_step_exec npm config set "$key" "$value" --userconfig="$config_file"
    else
      laptop_step_exec npm config delete "$key" --userconfig="$config_file"
    fi
  fi
}
