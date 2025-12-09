#!/usr/bin/env bash

# Test laptop_ini_get
assert "laptop_ini_get '$LAPTOP_TEST_DIR/ini_test_oneline.ini' 'root'" "root_value"
assert "laptop_ini_get '$LAPTOP_TEST_DIR/ini_test.ini' 'root'" "root_value"
assert "laptop_ini_get '$LAPTOP_TEST_DIR/ini_test.ini' 'section.section_key'" "section_value"
assert "laptop_ini_get '$LAPTOP_TEST_DIR/ini_test.ini' 'section2.section_key'" "section2_value"
assert "laptop_ini_get '$LAPTOP_TEST_DIR/ini_test.ini' 'unknown_key'" ""

# Test laptop_ini_ensure
ensure_ini_file="$TEST_TMP_DIR/ini_ensure.ini"
assert_raises "laptop_file_ensure '$ensure_ini_file'" 0
assert_raises "laptop_ini_ensure '$ensure_ini_file' 'root' 'root_value'" 0
assert_raises "laptop_ini_ensure '$ensure_ini_file' 'root_overwrite' 'root_overwrite_initial'" 0
assert_raises "laptop_ini_ensure '$ensure_ini_file' 'root_overwrite' 'root_overwrite_next'" 0
assert_raises "laptop_ini_ensure '$ensure_ini_file' 'section.new_key' 'value_initial'" 0
assert_raises "laptop_ini_ensure '$ensure_ini_file' 'section.new_key' 'value_next'" 0
assert_snapshot "cat '$ensure_ini_file'" "ini_ensure.ini.snap"
