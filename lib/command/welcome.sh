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
laptop_require "laptop_self_state_get"
laptop_require "laptop_self_state_ensure"
laptop_require "laptop_profile_version"
laptop_require "laptop_self_updated"
laptop_require "laptop_uptime"

__LAPTOP_WELCOME_COMMANDS=(setup upgrade cleanup)

laptop_command__welcome_status() {
  local command="$1"

  if [ "$command" = "setup" ]; then
    laptop_command__welcome_status_setup
    return
  fi

  local timestamp days delay now timestamp_seconds label

  timestamp="$(laptop_self_command_last_completed_at "$command")"
  delay="$(laptop_self_command_last_completed_delay "$command")"

  label="$(laptop_ansi "bold")laptop ${command}$(laptop_ansi "reset")"
  config_hint="$(laptop_ansi "dim")(recommended interval: $delay day(s))$(laptop_ansi "reset")"


  if [ -z "$timestamp" ]; then
    laptop_self_command_touch "$command"
    return
  fi

  now="$(laptop_date_to_epoch "$(laptop_date_now)")"
  timestamp_seconds="$(laptop_date_to_epoch "$timestamp")"
  if [ -z "$timestamp_seconds" ]; then
    laptop_command__welcome_notification warn "$label last execution date is invalid"
    return
  fi

  days=$(( (now - timestamp_seconds) / 86400 ))
  [ "$days" -lt 0 ] && days=0

  if [ "$days" -ge "$delay" ]; then
    laptop_command__welcome_notification warn "$label not executed since $days day(s) $config_hint"
  fi
}

laptop_command__welcome_status_setup() {
  local current_version completed_version seen_version seen_at delay now seen_at_seconds days label config_hint

  current_version="$(laptop_profile_version)"
  completed_version="$(laptop_self_state_get "setup_profile_version")"
  delay="$(laptop_self_command_last_completed_delay "setup")"

  label="$(laptop_ansi "bold")laptop setup$(laptop_ansi "reset")"
  config_hint="$(laptop_ansi "dim")(recommended interval: $delay day(s))$(laptop_ansi "reset")"

  if [ -n "$completed_version" ] && [ "$completed_version" = "$current_version" ]; then
    return
  fi

  seen_version="$(laptop_self_state_get "profile_version_seen")"
  seen_at="$(laptop_self_state_get "profile_version_seen_at")"
  if [ "$seen_version" != "$current_version" ]; then
    seen_at="$(laptop_date_now)"
    laptop_self_state_ensure "profile_version_seen" "$current_version"
    laptop_self_state_ensure "profile_version_seen_at" "$seen_at"
  fi

  now="$(laptop_date_to_epoch "$(laptop_date_now)")"
  seen_at_seconds="$(laptop_date_to_epoch "$seen_at")"
  if [ -z "$seen_at_seconds" ]; then
    laptop_command__welcome_notification warn "$label last execution date is invalid"
    return
  fi

  days=$(( (now - seen_at_seconds) / 86400 ))
  [ "$days" -lt 0 ] && days=0

  if [ "$days" -ge "$delay" ]; then
    laptop_command__welcome_notification warn "$label not launched for version $current_version $config_hint"
  fi
}

laptop_command__welcome() {
  laptop_handler_call "welcome-logo"

  {
    laptop_command__welcome_os;
    laptop_command__welcome_kernel;
    laptop_command__welcome_uptime;
    laptop_command__welcome_col "" ""
    laptop_command__welcome_gituser;
  } | column -t -s $'\t'

  echo ""
  laptop_command__welcome_status_outdated
  local index command
  for index in "${!__LAPTOP_WELCOME_COMMANDS[@]}"; do
    command="${__LAPTOP_WELCOME_COMMANDS[$index]}"
    laptop_command__welcome_status "$command"
  done
}

laptop_command__welcome_os() {
  if [ "$(uname -s)" = "Darwin" ]; then
    laptop_command__welcome_col "Operating system:" "$(sw_vers -productName) $(sw_vers -productVersion) (Darwin)"
  else
    laptop_command__welcome_col "Operating system:" "$(lsb_release -ds) ($(uname -o))"
  fi
}

laptop_command__welcome_kernel() {
  laptop_command__welcome_col "Kernel Information:" "$(uname -smr)"
}

laptop_command__welcome_uptime() {
  laptop_command__welcome_col "Uptime:" "$(laptop_ansi "white")Host up for $(laptop_ansi "cyan")$(laptop_print_uptime)"
}

laptop_command__welcome_gituser() {
  # Display the Git user if set, if not display nothing
  local git_user git_email
  git_user="$(git config --global user.name)"
  git_email="$(git config --global user.email)"
  if [ -n "$git_user" ] && [ -n "$git_email" ]; then
    laptop_command__welcome_col "Git User:" "$git_user <$git_email>"
  fi
}

laptop_command__welcome_status_outdated() {
  if ! laptop_self_updated --cache-max-age 86400; then
    laptop_command__welcome_notification "🆕" "New version of $(laptop_ansi "bold")laptop$(laptop_ansi "reset") is available! $(laptop_ansi "dim")(run $(laptop_ansi "bold")laptop self-update$(laptop_ansi "reset")$(laptop_ansi "dim") to update)$(laptop_ansi "reset")"
  fi
}

laptop_command__welcome_col() {
  echo -e "$(laptop_ansi "magenta")\\t${1}\\t$(laptop_ansi "cyan")${2}$(laptop_ansi "white")"
}

laptop_command__welcome_notification() {
  local level="$1"
  local message="$2"
  local icon="🔹"
  case "$level" in
    "warn")
      icon="🔸"
      ;;
    "error")
      icon="🔺"
      ;;
    *)
      icon="$level"
      ;;
  esac
  echo -e "  $icon $message"
}

laptop_print_uptime() {
  local up_seconds
  up_seconds="$(laptop_uptime)"

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
