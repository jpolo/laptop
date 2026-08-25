#!/usr/bin/env bash

# shellcheck disable=SC1091
source "$LAPTOP_LIB_DIR/command/welcome.sh"

WELCOME_STATE_DIR="$(mktemp -d)"
export LAPTOP_USER_STATE_DIR="$WELCOME_STATE_DIR"
WELCOME_OUTPUT_FILE="$(mktemp)"

LAPTOP_SETUP_DELAY=1 LAPTOP_UPGRADE_DELAY=1 LAPTOP_CLEANUP_DELAY=1 laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'Warning: Setup never executed' '$WELCOME_OUTPUT_FILE'" "0"
assert "grep -c 'Warning: Upgrade' '$WELCOME_OUTPUT_FILE'" "0"
assert "grep -c 'Warning: Cleanup' '$WELCOME_OUTPUT_FILE'" "0"
assert "laptop_self_command_last_completed_at upgrade" "$(laptop_date_now)"
assert "laptop_self_command_last_completed_at cleanup" "$(laptop_date_now)"

laptop_self_command_touch "setup" "$(laptop_date_now)"
laptop_self_command_touch "upgrade" "$(laptop_date_now)"
laptop_self_command_touch "cleanup" "$(laptop_date_now)"
LAPTOP_SETUP_DELAY=1 LAPTOP_UPGRADE_DELAY=1 LAPTOP_CLEANUP_DELAY=1 laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"

LAPTOP_SETUP_DELAY=0 LAPTOP_UPGRADE_DELAY=0 LAPTOP_CLEANUP_DELAY=0 laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "3"
