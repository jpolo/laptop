#!/usr/bin/env bash

SCRIPT_DIR="$(dirname "$0")"
cd "$SCRIPT_DIR/.." || exit 1

unset TERM;

ROOT_DIR=$(pwd)
export ROOT_DIR
export TEST_DIR=${TEST_DIR:-"$ROOT_DIR/test"}

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
