#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$LAPTOP_LIB_DIR/command/welcome.sh"

WELCOME_OUTPUT_FILE="$(mktemp)"

# Fixed "now" so examples are absolute and never depend on wall-clock time.
WELCOME_MOCK_NOW="2024-06-15T12:00:00Z"
.laptop_date_now_mock "$WELCOME_MOCK_NOW"


# Run a single "laptop welcome" command block with a given delay and
# capture its output.
#
# Usage:
#   .laptop_welcome_status_with_delay <command> <delay>
.laptop_welcome_status_with_delay() {
  local command="$1"
  local delay="$2"
  local env_name
  env_name="LAPTOP_$(echo "$command" | tr '[:lower:]' '[:upper:]')_DELAY"

  (
    export LAPTOP_SETUP_DELAY=9999
    export LAPTOP_UPGRADE_DELAY=9999
    export LAPTOP_CLEANUP_DELAY=9999

    export "$env_name=$delay"
    laptop_command__welcome_status "$command"
  ) >"$WELCOME_OUTPUT_FILE" 2>&1
}

## command: setup ##############################################################

# example: never executed -> warns "never executed"
.laptop_user_state_reset
.laptop_welcome_status_with_delay "setup" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "1"
assert "grep -c 'never executed' '$WELCOME_OUTPUT_FILE'" "1"

# example: executed exactly at the delay boundary -> not overdue yet
.laptop_user_state_reset
laptop_self_command_touch "setup" "2024-06-08T12:00:00Z" # 7 days before now
.laptop_welcome_status_with_delay "setup" 8
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"

# example: executed just before the delay is due -> overdue, warns
.laptop_user_state_reset
laptop_self_command_touch "setup" "2024-06-07T12:00:00Z" # 8 days before now
.laptop_welcome_status_with_delay "setup" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "1"
assert "grep -c 'not executed since 8 day(s)' '$WELCOME_OUTPUT_FILE'" "1"

# example: invalid stored timestamp -> warns about invalid date
.laptop_user_state_reset
laptop_self_command_touch "setup" "not-a-date"
.laptop_welcome_status_with_delay "setup" 7
assert "grep -c 'last execution date is invalid' '$WELCOME_OUTPUT_FILE'" "1"

## command: upgrade ############################################################

# example: never executed -> auto-touched, no warning
.laptop_user_state_reset
.laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_command_last_completed_at upgrade" "$WELCOME_MOCK_NOW"

# example: executed recently -> no warning
.laptop_user_state_reset
laptop_self_command_touch "upgrade" "$WELCOME_MOCK_NOW"
.laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"

# example: overdue -> warns
.laptop_user_state_reset
laptop_self_command_touch "upgrade" "2024-06-01T12:00:00Z" # 14 days before now
.laptop_welcome_status_with_delay "upgrade" 7
assert "grep -c 'not executed since 14 day(s)' '$WELCOME_OUTPUT_FILE'" "1"

## command: cleanup ############################################################

# example: never executed -> auto-touched, no warning
.laptop_user_state_reset
.laptop_welcome_status_with_delay "cleanup" 7
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_command_last_completed_at cleanup" "$WELCOME_MOCK_NOW"

# example: overdue -> warns
.laptop_user_state_reset
laptop_self_command_touch "cleanup" "2024-05-15T12:00:00Z" # 31 days before now
.laptop_welcome_status_with_delay "cleanup" 30
assert "grep -c 'not executed since 31 day(s)' '$WELCOME_OUTPUT_FILE'" "1"

## laptop_command__welcome: aggregates all commands ############################

.laptop_user_state_reset
laptop_self_command_touch "setup" "2024-06-14T12:00:00Z"   # 1 day before now, not due
laptop_self_command_touch "upgrade" "2024-06-01T12:00:00Z" # 14 days before now, overdue
laptop_self_command_touch "cleanup" "2024-06-14T12:00:00Z" # 1 day before now, not due
LAPTOP_SETUP_DELAY=7 LAPTOP_UPGRADE_DELAY=7 LAPTOP_CLEANUP_DELAY=7 \
  laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "1"
assert "grep -c 'laptop upgrade' '$WELCOME_OUTPUT_FILE'" "1"
