#!/usr/bin/env bash
# Test laptop_state_set

state_set_dir="$TEST_TMP_DIR/state_set"

# Creates the state dir and file when missing
LAPTOP_USER_STATE_DIR="$state_set_dir/new"
assert_raises "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_set 'setup_last_completed_at' '2024-01-02T03:04:05Z'" 0
assert "cat '$LAPTOP_USER_STATE_DIR/state'" "setup_last_completed_at=2024-01-02T03:04:05Z"
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'setup_last_completed_at'" "2024-01-02T03:04:05Z"

# Updates an existing key without touching other keys
LAPTOP_USER_STATE_DIR="$state_set_dir/existing"
mkdir -p "$LAPTOP_USER_STATE_DIR"
echo 'upgrade_last_completed_at=2024-01-01T00:00:00Z' >"$LAPTOP_USER_STATE_DIR/state"
assert_raises "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_set 'setup_last_completed_at' '2024-02-02T00:00:00Z'" 0
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'upgrade_last_completed_at'" "2024-01-01T00:00:00Z"
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'setup_last_completed_at'" "2024-02-02T00:00:00Z"

assert_raises "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_set 'setup_last_completed_at' '2024-03-03T00:00:00Z'" 0
assert "LAPTOP_USER_STATE_DIR='$LAPTOP_USER_STATE_DIR' laptop_state_get 'setup_last_completed_at'" "2024-03-03T00:00:00Z"
