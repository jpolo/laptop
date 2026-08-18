#!/usr/bin/env bash

source "$LAPTOP_LIB_DIR/command/welcome.sh"

WELCOME_STATE_DIR="$(mktemp -d)"
export LAPTOP_USER_STATE_DIR="$WELCOME_STATE_DIR"
laptop_self_state_ensure "setup_last_completed_at" "$(laptop_date_now)"
laptop_self_state_ensure "upgrade_last_completed_at" "$(laptop_date_now)"
laptop_self_state_ensure "cleanup_last_completed_at" "$(laptop_date_now)"
WELCOME_OUTPUT_FILE="$(mktemp)"
LAPTOP_SETUP_INTERVAL=1 LAPTOP_UPGRADE_INTERVAL=1 LAPTOP_CLEANUP_INTERVAL=1 laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'day(s) since last execution' '$WELCOME_OUTPUT_FILE'" "3"
assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "0"

LAPTOP_SETUP_INTERVAL=0 LAPTOP_UPGRADE_INTERVAL=0 LAPTOP_CLEANUP_INTERVAL=0 laptop_command__welcome >"$WELCOME_OUTPUT_FILE" 2>&1

assert "grep -c 'Warning:' '$WELCOME_OUTPUT_FILE'" "3"

WELCOME_CONFIG_DIR="$(mktemp -d)"
WELCOME_CONFIG_FILE="$WELCOME_CONFIG_DIR/config.ini"
printf '[.anon]\nsetup_interval=1\n' >"$WELCOME_CONFIG_FILE"
export LAPTOP_USER_CONFIG_FILE="$WELCOME_CONFIG_FILE"
unset LAPTOP_SETUP_INTERVAL
assert "laptop_command__welcome_interval setup 7" "1"
