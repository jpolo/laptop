#!/usr/bin/env bash
# Test laptop_state_get

state_get_dir="$TEST_TMP_DIR/state_get"
mkdir -p "$state_get_dir"

# Non existing state file
LAPTOP_USER_STATE_DIR="$state_get_dir/missing"
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'setup_last_completed_at'" ""

# Existing state file
LAPTOP_USER_STATE_DIR="$state_get_dir/present"
mkdir -p "$LAPTOP_USER_STATE_DIR"
echo 'setup_last_completed_at=2024-01-02T03:04:05Z' >"$LAPTOP_USER_STATE_DIR/state.vars"
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'setup_last_completed_at'" "2024-01-02T03:04:05Z"
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'non_existing_key'" ""
