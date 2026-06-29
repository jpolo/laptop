#!/usr/bin/env bash

# Default: without export
plain_file="$TEST_TMP_DIR/file_var_set"
touch "$plain_file"
assert_raises "laptop_file_var_set '$plain_file' 'MY_VARIABLE' 'MY_VALUE'" 0
assert "grep -E '^MY_VARIABLE=' '$plain_file'" "MY_VARIABLE=MY_VALUE"
assert "laptop_file_var_get '$plain_file' 'MY_VARIABLE'" "MY_VALUE"
assert_raises "grep -qE '^MY_VARIABLE=' '$plain_file'" 0
assert_raises "grep -qE '^export MY_VARIABLE=' '$plain_file'" 1

assert_raises "laptop_file_var_set '$plain_file' 'MY_VARIABLE' 'MY_VALUE_2'" 0
assert "grep -E '^MY_VARIABLE=' '$plain_file'" "MY_VARIABLE=MY_VALUE_2"
assert "laptop_file_var_get '$plain_file' 'MY_VARIABLE'" "MY_VALUE_2"

# With --export
export_file="$TEST_TMP_DIR/file_var_set_export"
touch "$export_file"
assert_raises "laptop_file_var_set '$export_file' 'MY_VARIABLE' 'MY_VALUE' --export" 0
assert "grep -E '^export MY_VARIABLE=' '$export_file'" "export MY_VARIABLE=MY_VALUE"
assert "laptop_file_var_get '$export_file' 'MY_VARIABLE'" "MY_VALUE"
assert_raises "grep -qE '^export MY_VARIABLE=' '$export_file'" 0

# Convert plain assignment to export
plain_to_export="$TEST_TMP_DIR/plain_to_export"
echo 'MY_VARIABLE=old' >"$plain_to_export"
assert_raises "laptop_file_var_set '$plain_to_export' 'MY_VARIABLE' 'new' --export" 0
assert "cat '$plain_to_export'" 'export MY_VARIABLE=new'
assert_raises "grep -qE '^export MY_VARIABLE=' '$plain_to_export'" 0

# Convert export assignment to plain
export_to_plain="$TEST_TMP_DIR/export_to_plain"
echo 'export MY_VARIABLE=old' >"$export_to_plain"
assert_raises "laptop_file_var_set '$export_to_plain' 'MY_VARIABLE' 'new'" 0
assert "cat '$export_to_plain'" 'MY_VARIABLE=new'
assert_raises "grep -qE '^export MY_VARIABLE=' '$export_to_plain'" 1

# Regression: original sed -i without backup extension fails on BSD sed (macOS)
_file_var_set_old_sed_inplace() {
  local script_file="$1"
  local var_name="$2"
  local new_value="$3"
  sed -i "s/^export ${var_name}=.*/export ${var_name}=${new_value}/" "$script_file"
}
if ! sed --version 2>&1 | grep -q GNU; then
  echo 'export FOO=old' >"$TEST_TMP_DIR/bsd_sed_inplace"
  assert_raises "_file_var_set_old_sed_inplace '$TEST_TMP_DIR/bsd_sed_inplace' 'FOO' 'bar'" 1
fi

# Regression: sed s/// cannot substitute values containing slashes (all platforms).
# BSD sed may exit 0 despite errors, so assert the file is left unchanged.
_file_var_set_old_sed_substitute() {
  local script_file="$1"
  local var_name="$2"
  local new_value="$3"
  sed -i.bak "s/^export ${var_name}=.*/export ${var_name}=${new_value}/" "$script_file" 2>/dev/null
  rm -f "${script_file}.bak"
}
github_token_value='"\$(GITHUB_TOKEN= gh auth token 2>/dev/null)"'
sed_slash_file="$TEST_TMP_DIR/sed_slash_value"
echo 'export GITHUB_TOKEN=old' >"$sed_slash_file"
_file_var_set_old_sed_substitute "$sed_slash_file" "GITHUB_TOKEN" "$github_token_value"
assert "cat '$sed_slash_file'" 'export GITHUB_TOKEN=old'

# Fix: update existing variable with slashes and shell metacharacters (macOS + Linux)
github_token_file="$TEST_TMP_DIR/github_token"
echo 'export GITHUB_TOKEN=old' >"$github_token_file"
assert_raises "laptop_file_var_set '$github_token_file' 'GITHUB_TOKEN' '$github_token_value' --export" 0
assert "sed -n 's/^export GITHUB_TOKEN=//p' '$github_token_file'" "$github_token_value"
assert_raises "grep -qE '^export GITHUB_TOKEN=' '$github_token_file'" 0
