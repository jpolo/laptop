#!/usr/bin/env bash

# Test laptop_file_var_set
touch "$TEST_TMP_DIR/file_var_set"
assert_raises "laptop_file_var_set '$TEST_TMP_DIR/file_var_set' 'MY_VARIABLE' 'MY_VALUE'" 0
assert "laptop_file_var_get '$TEST_TMP_DIR/file_var_set' 'MY_VARIABLE'" "MY_VALUE"

assert_raises "laptop_file_var_set '$TEST_TMP_DIR/file_var_set' 'MY_VARIABLE' 'MY_VALUE_2'" 0
assert "laptop_file_var_get '$TEST_TMP_DIR/file_var_set' 'MY_VARIABLE'" "MY_VALUE_2"
