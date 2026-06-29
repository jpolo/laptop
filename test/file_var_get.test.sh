#!/usr/bin/env bash

# Test laptop_file_var_get with export
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_VARIABLE'" "MY_VALUE"
# shellcheck disable=SC2016
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_EXPRESSION'" '\$(foo)'
assert_raises "grep -qE '^export MY_VARIABLE=' '$LAPTOP_TEST_DIR/file_var_get'" 0

# Test laptop_file_var_get without export
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_PLAIN_VAR'" "plain_value"
# shellcheck disable=SC2016
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_PLAIN_EXPRESSION'" '\$(bar)'
assert_raises "grep -qE '^export MY_PLAIN_VAR=' '$LAPTOP_TEST_DIR/file_var_get'" 1

assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_NON_EXISTING'" ''
assert_raises "grep -qE '^export MY_NON_EXISTING=' '$LAPTOP_TEST_DIR/file_var_get'" 1
