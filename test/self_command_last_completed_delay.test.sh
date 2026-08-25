#!/usr/bin/env bash

TEST_DELAY_CONFIG_DIR="$(mktemp -d)"
TEST_DELAY_CONFIG_FILE="$TEST_DELAY_CONFIG_DIR/config.ini"
printf '[.anon]\ncommand_with_config_delay=11\n' >"$TEST_DELAY_CONFIG_FILE"
export LAPTOP_USER_CONFIG_FILE="$TEST_DELAY_CONFIG_FILE"

# From config
assert "laptop_self_command_last_completed_delay command_with_config 7" "11"

# From default
assert "laptop_self_command_last_completed_delay command_without_config 7" "7"

# From env
export LAPTOP_COMMAND_WITH_CONFIG_DELAY=5
assert "laptop_self_command_last_completed_delay command_with_config 7" "5"

# Invalid delay value
export LAPTOP_INVALID_DELAY=abc
assert_raises "laptop_self_command_last_completed_delay invalid 7" "1"


