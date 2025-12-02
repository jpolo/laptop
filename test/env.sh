#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1

# Disable colors
unset TERM;
export NO_COLOR=1

ROOT_DIR=$(pwd)
export ROOT_DIR
export TEST_DIR=${TEST_DIR:-"$ROOT_DIR/test"}

export OK_STATUS="OK"

# Source assert.sh
source "$TEST_DIR/assert.sh"
source "$TEST_DIR/assert_snapshot.sh"

# Variables
LAPTOP_HOME="$ROOT_DIR"
export LAPTOP_HOME
export LAPTOP_PROFILE=default

# Source laptop environment
source "$TEST_DIR/../lib/env.sh"

# Temporary directory
TMPDIR=$(mktemp -d 2>/dev/null || mktemp -d -t 'laptop')
export TMPDIR
