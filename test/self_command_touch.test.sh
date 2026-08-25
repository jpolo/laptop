#!/usr/bin/env bash

SELF_COMMAND_TOUCH_STATE_DIR="$(mktemp -d)"
export LAPTOP_USER_STATE_DIR="$SELF_COMMAND_TOUCH_STATE_DIR"

laptop_self_command_touch "upgrade" "2024-01-02T03:04:05Z"

assert "laptop_self_command_last_completed_at upgrade" "2024-01-02T03:04:05Z"
