#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$LAPTOP_LIB_DIR/command/welcome.sh"

WELCOME_OUTPUT_FILE="$(mktemp)"
WELCOME_PROFILE_VERSION="1.2.3"

# Fixed "now" so examples are absolute and never depend on wall-clock time.
WELCOME_MOCK_NOW="2024-06-15T12:00:00Z"
_laptop_date_now_mock "$WELCOME_MOCK_NOW"

## macOS support ##############################################################

assert "(uname() { printf 'Darwin\\n'; }; sw_vers() { case \"\$1\" in -productName) printf 'macOS\\n' ;; -productVersion) printf '14.5\\n' ;; esac; }; laptop_command__welcome_os)" $'\tOperating system:\tmacOS 14.5 (Darwin)'
assert "(uname() { printf 'Darwin\\n'; }; sysctl() { printf '{ sec = 1718452680, usec = 196255 } Sat Jun 15 11:58:00 2024\\n'; }; laptop_date_now() { printf '2024-06-15T12:00:00Z\\n'; }; laptop_date_to_epoch() { printf '1718452800\\n'; }; laptop_print_uptime)" "00 hours 02 minutes"


# Run a single "laptop welcome" command block with a given delay and
# capture its output.
#
# Usage:
#   _laptop_welcome_status_with_delay <command> <delay>
_laptop_welcome_status_with_delay() {
  local command="$1"
  local delay="$2"
  local env_name
  env_name="LAPTOP_$(echo "$command" | tr '[:lower:]' '[:upper:]')_DELAY"

  (
    export LAPTOP_SETUP_DELAY=9999
    export LAPTOP_UPGRADE_DELAY=9999
    export LAPTOP_CLEANUP_DELAY=9999

    export "$env_name=$delay"
    # shellcheck disable=SC2329 # invoked indirectly by laptop_command__welcome_status
    laptop_profile_version() { echo "$WELCOME_PROFILE_VERSION"; }
    laptop_command__welcome_status "$command"
  ) >"$WELCOME_OUTPUT_FILE" 2>&1
}

_laptop_touch_profile_version() {
  local timestamp="$1"
  (
    # shellcheck disable=SC2329 # invoked indirectly by laptop_self_command_touch
    laptop_profile_version() { echo "$WELCOME_PROFILE_VERSION"; }
    laptop_self_command_touch "setup" "$timestamp"
  )
}

## command: setup ##############################################################

# example: current version already launched -> no warning even if last run is old
_laptop_user_state_reset
_laptop_touch_profile_version "2024-01-01T12:00:00Z"
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'not launched' '$WELCOME_OUTPUT_FILE'" "0"

# example: version not launched, first seen now -> stamps seen-at, no warning
_laptop_user_state_reset
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'not launched' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_state_get profile_version_seen" "$WELCOME_PROFILE_VERSION"
assert "laptop_self_state_get profile_version_seen_at" "$WELCOME_MOCK_NOW"

# example: same version, seen-at inside the delay -> no warning
_laptop_user_state_reset
laptop_self_state_ensure "profile_version_seen" "$WELCOME_PROFILE_VERSION"
laptop_self_state_ensure "profile_version_seen_at" "2024-06-14T12:00:00Z" # 1 day before now
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'not launched' '$WELCOME_OUTPUT_FILE'" "0"

# example: same version, seen-at at the delay boundary -> warns
_laptop_user_state_reset
laptop_self_state_ensure "profile_version_seen" "$WELCOME_PROFILE_VERSION"
laptop_self_state_ensure "profile_version_seen_at" "2024-06-13T12:00:00Z" # 2 days before now
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'not launched for version 1.2.3' '$WELCOME_OUTPUT_FILE'" "1"

# example: new current version resets the clock even if an older seen-at exists
_laptop_user_state_reset
laptop_self_state_ensure "profile_version_seen" "1.0.0"
laptop_self_state_ensure "profile_version_seen_at" "2024-01-01T12:00:00Z"
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'not launched' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_state_get profile_version_seen" "$WELCOME_PROFILE_VERSION"
assert "laptop_self_state_get profile_version_seen_at" "$WELCOME_MOCK_NOW"

# example: invalid stored seen-at -> warns about invalid date
_laptop_user_state_reset
laptop_self_state_ensure "profile_version_seen" "$WELCOME_PROFILE_VERSION"
laptop_self_state_ensure "profile_version_seen_at" "not-a-date"
_laptop_welcome_status_with_delay "setup" 2
assert "grep -c 'last execution date is invalid' '$WELCOME_OUTPUT_FILE'" "1"

## command: upgrade ############################################################

# example: never executed -> auto-touched, no warning
_laptop_user_state_reset
_laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_command_last_completed_at upgrade" "$WELCOME_MOCK_NOW"

# example: executed recently -> no warning
_laptop_user_state_reset
laptop_self_command_touch "upgrade" "$WELCOME_MOCK_NOW"
_laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"

# example: overdue -> warns
_laptop_user_state_reset
laptop_self_command_touch "upgrade" "2024-06-01T12:00:00Z" # 14 days before now
_laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'not executed since 14 day(s)' '$WELCOME_OUTPUT_FILE'" "1"

## command: cleanup ############################################################

# example: never executed -> auto-touched, no warning
_laptop_user_state_reset
_laptop_welcome_status_with_delay "cleanup" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_command_last_completed_at cleanup" "$WELCOME_MOCK_NOW"

# example: overdue -> warns
_laptop_user_state_reset
laptop_self_command_touch "cleanup" "2024-05-15T12:00:00Z" # 31 days before now
_laptop_welcome_status_with_delay "cleanup" 30
assert "grep -c 'not executed since 31 day(s)' '$WELCOME_OUTPUT_FILE'" "1"

## uptime status ###############################################################

_laptop_welcome_uptime_status_with_delay() {
  local mock_up_seconds="$1"
  local delay="$2"

  (
    export LAPTOP_UPTIME_DELAY="$delay"
    # Use a distinct name so the stub is not shadowed by
    # laptop_command__welcome_uptime_status's local up_seconds.
    # shellcheck disable=SC2329 # invoked indirectly by laptop_command__welcome_uptime_status
    laptop_uptime() { echo "$mock_up_seconds"; }
    laptop_command__welcome_uptime_status
  ) >"$WELCOME_OUTPUT_FILE" 2>&1
}

# example: below the threshold -> no warning
_laptop_welcome_uptime_status_with_delay "$((29 * 86400))" 30
assert "grep -c 'reboot recommended' '$WELCOME_OUTPUT_FILE'" "0"

# example: exactly at the threshold -> warns
_laptop_welcome_uptime_status_with_delay "$((30 * 86400))" 30
assert "grep -c 'Host up for 30 day(s), reboot recommended' '$WELCOME_OUTPUT_FILE'" "1"

# example: above the threshold -> warns with day count
_laptop_welcome_uptime_status_with_delay "$((31 * 86400))" 30
assert "grep -c 'Host up for 31 day(s), reboot recommended' '$WELCOME_OUTPUT_FILE'" "1"

## laptop_command__welcome: aggregates all commands ############################

_laptop_user_state_reset
_laptop_touch_profile_version "2024-06-14T12:00:00Z"
laptop_self_command_touch "upgrade" "2024-06-01T12:00:00Z" # 14 days before now, overdue
laptop_self_command_touch "cleanup" "2024-06-14T12:00:00Z" # 1 day before now, not due
(
  # shellcheck disable=SC2329 # invoked indirectly by laptop_command__welcome
  laptop_profile_version() { echo "$WELCOME_PROFILE_VERSION"; }
  # shellcheck disable=SC2329 # invoked indirectly by laptop_command__welcome
  laptop_uptime() { echo 120; }
  LAPTOP_SETUP_DELAY=2 LAPTOP_UPGRADE_DELAY=7 LAPTOP_CLEANUP_DELAY=7 LAPTOP_UPTIME_DELAY=9999 \
    laptop_command__welcome
) >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'not executed since' '$WELCOME_OUTPUT_FILE'" "1"
assert "grep -c 'laptop upgrade' '$WELCOME_OUTPUT_FILE'" "1"
assert "grep -c 'not launched' '$WELCOME_OUTPUT_FILE'" "0"
assert "grep -c 'reboot recommended' '$WELCOME_OUTPUT_FILE'" "0"
