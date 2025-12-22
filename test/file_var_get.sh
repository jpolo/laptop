#!/usr/bin/env bash

# Test laptop_file_var_get
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_VARIABLE'" "MY_VALUE"
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_EXPRESSION'" '$(foo bar)'
assert "laptop_file_var_get '$LAPTOP_TEST_DIR/file_var_get' 'MY_NON_EXISTING'" ''
