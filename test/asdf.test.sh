#!/usr/bin/env bash

ASDF_TEST_DIR="$TEST_TMP_DIR/asdf-dirs"
ASDF_TEST_INSTALL_DIR="$ASDF_TEST_DIR/install"
ASDF_TEST_DATA_DIR="$ASDF_TEST_DIR/data"
ASDF_TEST_CALLS="$ASDF_TEST_DIR/calls"

mkdir -p "$ASDF_TEST_INSTALL_DIR/shims" "$ASDF_TEST_DATA_DIR/shims"
: >"$ASDF_TEST_CALLS"

source "$LAPTOP_HOME/lib/package/asdf.sh"

(
  laptop_package_ensure_default() {
    printf 'package %s\n' "$*" >>"$ASDF_TEST_CALLS"
  }
  export ASDF_DIR="$ASDF_TEST_INSTALL_DIR"
  export ASDF_DATA_DIR="$ASDF_TEST_DATA_DIR"
  LAPTOP_PACKAGE_MANAGER="brew"
  laptop_package_ensure__asdf asdf --status absent >/dev/null
)
assert_raises "grep -Fx 'package asdf --status absent' '$ASDF_TEST_CALLS'" 0
assert_raises "test ! -d '$ASDF_TEST_INSTALL_DIR'" 0
assert_raises "test ! -d '$ASDF_TEST_DATA_DIR'" 0

ASDF_TEST_STATUS=0
(
  laptop_package_ensure_default() { :; }
  export ASDF_DIR="$ASDF_TEST_INSTALL_DIR"
  export ASDF_DATA_DIR="$ASDF_TEST_DATA_DIR"
  LAPTOP_PACKAGE_MANAGER="brew"
  laptop_package_ensure__asdf asdf --status absent >/dev/null
) || ASDF_TEST_STATUS=$?
assert "echo '$ASDF_TEST_STATUS'" "0"

mkdir -p "$ASDF_TEST_INSTALL_DIR/shims" "$ASDF_TEST_DATA_DIR/shims"
(
  export ASDF_DIR="$ASDF_TEST_INSTALL_DIR"
  export ASDF_DATA_DIR="$ASDF_TEST_DATA_DIR"
  LAPTOP_PACKAGE_MANAGER="apt-get"
  laptop_package_ensure__asdf asdf --status absent >/dev/null
)
assert_raises "test ! -d '$ASDF_TEST_INSTALL_DIR'" 0
assert_raises "test ! -d '$ASDF_TEST_DATA_DIR'" 0

ASDF_TEST_STATUS=0
(
  export ASDF_DIR="$ASDF_TEST_INSTALL_DIR"
  export ASDF_DATA_DIR="$ASDF_TEST_DATA_DIR"
  LAPTOP_PACKAGE_MANAGER="apt-get"
  laptop_package_ensure__asdf asdf --status absent >/dev/null
) || ASDF_TEST_STATUS=$?
assert "echo '$ASDF_TEST_STATUS'" "0"
