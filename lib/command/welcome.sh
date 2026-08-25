#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_log"
laptop_require "laptop_date_now"
laptop_require "laptop_date_to_epoch"
laptop_require "laptop_self_config_get"
laptop_require "laptop_self_command_last_completed_at"
laptop_require "laptop_self_command_last_completed_delay"
laptop_require "laptop_self_command_touch"

__LAPTOP_WELCOME_COMMANDS=(setup upgrade cleanup)

laptop_command__welcome_status() {
  local command="$1"
  local timestamp days delay now timestamp_seconds label

  case "$command" in
    setup) label="Setup" ;;
    upgrade) label="Upgrade" ;;
    cleanup) label="Cleanup" ;;
  esac

  timestamp="$(laptop_self_command_last_completed_at "$command")"
  delay="$(laptop_self_command_last_completed_delay "$command")"

  if [ -z "$timestamp" ]; then
    if [ "$command" = "upgrade" ] || [ "$command" = "cleanup" ]; then
      laptop_self_command_touch "$command"
      return
    fi

    laptop_log warn "$label never executed"
    return
  fi

  now="$(laptop_date_to_epoch "$(laptop_date_now)")"
  timestamp_seconds="$(laptop_date_to_epoch "$timestamp")"
  if [ -z "$timestamp_seconds" ]; then
    laptop_log warn "$label last execution date is invalid"
    return
  fi

  days=$(( (now - timestamp_seconds) / 86400 ))
  [ "$days" -lt 0 ] && days=0

  if [ "$days" -ge "$delay" ]; then
    laptop_log warn "$label not executed since $days day(s) (interval: $delay day(s))"
  fi
}

laptop_command__welcome() {
  laptop_handler_call "welcome-logo"

  local index command
  for index in "${!__LAPTOP_WELCOME_COMMANDS[@]}"; do
    command="${__LAPTOP_WELCOME_COMMANDS[$index]}"
    laptop_command__welcome_status "$command"
  done
}
