#!/usr/bin/env bash

SELF_COMMAND_TOUCH_STATE_DIR="$(mktemp -d)"
export LAPTOP_USER_STATE_DIR="$SELF_COMMAND_TOUCH_STATE_DIR"

laptop_self_command_touch "upgrade" "2024-01-02T03:04:05Z"

assert "laptop_self_command_last_completed_at upgrade" "2024-01-02T03:04:05Z"
assert "laptop_self_state_get upgrade_self_version" "$(laptop_self_version)"
assert "laptop_self_state_get upgrade_profile_version" "$(laptop_profile_version)"

(
  laptop_profile_version() { echo "9.9.9"; }
  laptop_self_command_touch "setup" "2024-01-02T03:04:05Z"
)
assert "laptop_self_command_last_completed_at setup" "2024-01-02T03:04:05Z"
assert "laptop_self_state_get setup_self_version" "$(laptop_self_version)"
assert "laptop_self_state_get setup_profile_version" "9.9.9"
