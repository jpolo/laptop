#!/usr/bin/env bash

laptop_require "laptop_handler_call"
laptop_require "laptop_ansi"
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

  timestamp="$(laptop_self_command_last_completed_at "$command")"
  delay="$(laptop_self_command_last_completed_delay "$command")"

  label="$(laptop_ansi "bold")laptop ${command}$(laptop_ansi "reset")"
  config_hint="$(laptop_ansi "dim")(recommended interval: $delay day(s))$(laptop_ansi "reset")"


  if [ -z "$timestamp" ]; then
    if [ "$command" = "upgrade" ] || [ "$command" = "cleanup" ]; then
      laptop_self_command_touch "$command"
      return
    fi

    laptop_log warn "$label never executed $config_hint"
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
    laptop_log warn "$label not executed since $days day(s) $config_hint"
  fi
}

laptop_command__welcome() {
  laptop_handler_call "welcome-logo"
  {
    laptop_command__welcome_os;
    laptop_command__welcome_kernel;
    laptop_command__welcome_uptime
  } | column -t -s $'\t'
  
  
  local index command
  for index in "${!__LAPTOP_WELCOME_COMMANDS[@]}"; do
    command="${__LAPTOP_WELCOME_COMMANDS[$index]}"
    laptop_command__welcome_status "$command"
  done
}

laptop_command__welcome_os() {
  laptop_command__welcome_col "Operating system:" "$(lsb_release -ds) ($(uname -o))"
}

laptop_command__welcome_kernel() {
  laptop_command__welcome_col "Kernel Information:" "$(uname -smr)"
}

laptop_command__welcome_uptime() {
  laptop_command__welcome_col "Uptime:" "$(laptop_ansi "white")Host up for $(laptop_ansi "cyan")$(laptop_print_uptime)"
}

laptop_command__welcome_col() {
  echo -e "$(laptop_ansi "magenta")\\t${1}\\t$(laptop_ansi "cyan")${2}$(laptop_ansi "white")"
}

laptop_print_uptime() {
  local up_seconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
  local mins=$(( (up_seconds / 60) % 60 ))
  local hours=$(( (up_seconds / 3600) % 24 ))
  local days=$(( up_seconds / 86400 ))
  local uptime
  if [ "$days" -eq 0 ]; then
    uptime="$(printf "%02d hours %02d minutes" "$hours" "$mins")"
  else
    uptime="$(printf "%d days %02d hours %02d minutes" "$days" "$hours" "$mins")"
  fi
  echo "$uptime"
}