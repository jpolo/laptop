#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_log"
laptop_require "laptop_date_now"
laptop_require "laptop_date_to_epoch"
laptop_require "laptop_self_config_get"
laptop_require "laptop_self_command_last_completed_at"

__LAPTOP_WELCOME_COMMANDS=(setup upgrade cleanup)
__LAPTOP_WELCOME_DEFAULT_INTERVALS=(7 7 30)

laptop_command__welcome_interval() {
  local command="$1"
  local default_interval="$2"
  local variable_name
  local config_key="${command}_interval"

  case "$command" in
    setup) variable_name="LAPTOP_SETUP_INTERVAL" ;;
    upgrade) variable_name="LAPTOP_UPGRADE_INTERVAL" ;;
    cleanup) variable_name="LAPTOP_CLEANUP_INTERVAL" ;;
  esac

  local interval="${!variable_name:-$(laptop_self_config_get "$config_key")}"

  if [[ ! "$interval" =~ ^[0-9]+$ ]]; then
    interval="$default_interval"
  fi

  echo "$interval"
}

laptop_command__welcome_status() {
  local command="$1"
  local default_interval="$2"
  local timestamp days interval now timestamp_seconds label

  case "$command" in
    setup) label="Setup" ;;
    upgrade) label="Upgrade" ;;
    cleanup) label="Cleanup" ;;
  esac

  timestamp="$(laptop_self_command_last_completed_at "$command")"
  interval="$(laptop_command__welcome_interval "$command" "$default_interval")"

  if [ -z "$timestamp" ]; then
    echo "$label: never"
    laptop_log warn "$label not executed since setup"
    return
  fi

  now="$(laptop_date_to_epoch "$(laptop_date_now)")"
  timestamp_seconds="$(laptop_date_to_epoch "$timestamp")"
  if [ -z "$timestamp_seconds" ]; then
    echo "$label: unknown"
    laptop_log warn "$label last execution date is invalid"
    return
  fi

  days=$(( (now - timestamp_seconds) / 86400 ))
  [ "$days" -lt 0 ] && days=0
  echo "$label: $days day(s) since last execution"

  if [ "$days" -ge "$interval" ]; then
    laptop_log warn "$label not executed since $days day(s) (interval: $interval day(s))"
  fi
}

laptop_command__welcome() {
  laptop_handler_call "welcome-logo"

  local index command
  for index in "${!__LAPTOP_WELCOME_COMMANDS[@]}"; do
    command="${__LAPTOP_WELCOME_COMMANDS[$index]}"
    laptop_command__welcome_status "$command" "${__LAPTOP_WELCOME_DEFAULT_INTERVALS[$index]}"
  done
}
