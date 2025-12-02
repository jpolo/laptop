#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"

# Source assert.sh
source "$SCRIPT_DIR/env.sh"

echo "Running tests in temporary directory: $TMPDIR"

# source *.test.sh files
for file in "$TEST_DIR"/*.test.sh; do
  # shellcheck disable=SC1090
  source "$file"
done

assert_end
