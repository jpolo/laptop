#!/usr/bin/env bash

# Test laptop_ini_get

assert "laptop_ini_get '$TEST_DIR/ini_test.ini' 'root'" "root_value"
assert "laptop_ini_get '$TEST_DIR/ini_test.ini' 'section.section_key'" "section_value"
assert "laptop_ini_get '$TEST_DIR/ini_test.ini' 'section2.section2_key'" "section2_value"
assert "laptop_ini_get '$TEST_DIR/ini_test.ini' 'unknown_key'" ""
