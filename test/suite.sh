#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"

# Source assert.sh
# shellcheck disable=SC1091
source "$SCRIPT_DIR/env.sh"

echo "Running tests in temporary directory: $TEST_TMP_DIR"

# source *.test.sh files
for file in "$LAPTOP_TEST_DIR"/*.test.sh; do
  # shellcheck disable=SC1090
  source "$file"
done

assert_end
