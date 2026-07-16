#!/usr/bin/env bash

laptop_require "laptop_self_version"
laptop_require "laptop_self_latest_version"

# laptop_self_version returns a non-empty string
assert_raises "[ -n \"\$(laptop_self_version)\" ]" 0

# laptop_self_version output is consistent across calls
assert "laptop_self_version" "$(laptop_self_version)"

# laptop_self_latest_version returns a non-empty string
# (may return "unknown" when offline/no remote — that is still non-empty)
assert_raises "[ -n \"\$(laptop_self_latest_version)\" ]" 0

# doctor command runs without error and contains expected labels
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Version'" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Latest'" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Status'" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Install'" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Profile'" 0
assert_raises "source \"$LAPTOP_LIB_DIR/command/doctor.sh\" && laptop_command__doctor | grep -q 'Disk'" 0
