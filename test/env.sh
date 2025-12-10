#!/usr/bin/env bash
# shellcheck disable=SC1091

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1

# Disable colors
unset TERM;
export NO_COLOR=1

# Variables
LAPTOP_HOME="$(pwd)"
export LAPTOP_HOME
export LAPTOP_PROFILE=default

# Source laptop environment
source "$LAPTOP_HOME/lib/init.sh"

# Source assert.sh
source "$LAPTOP_HOME/test/assert.sh"
source "$LAPTOP_HOME/test/assert_snapshot.sh"

# Temporary directory
if [ -z "$TEST_TMP_DIR" ];then
  TEST_TMP_DIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'laptop')
  export TEST_TMP_DIR
fi

