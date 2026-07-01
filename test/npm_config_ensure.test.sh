#!/usr/bin/env bash

if command -v npm >/dev/null 2>&1; then
  npm_config_file="$TEST_TMP_DIR/npm_config_ensure.npmrc"
  export npm_config_userconfig="$npm_config_file"
  touch "$npm_config_file"

  auth_key="//npm.pkg.github.com/:_authToken"
  # shellcheck disable=SC2016
  auth_value='${GITHUB_TOKEN}'
  # shellcheck disable=SC2034
  GITHUB_TOKEN=interpolated-secret-token

  assert_raises "laptop_npm_config_ensure '$auth_key' '$auth_value'" 0
  assert "grep -F '${auth_key}=${auth_value}' '$npm_config_file'" "${auth_key}=${auth_value}"
  assert_raises "grep -F 'interpolated-secret-token' '$npm_config_file'" 1

  assert_raises "laptop_npm_config_ensure '$auth_key' '$auth_value'" 0
  assert "grep -cF '${auth_key}=${auth_value}' '$npm_config_file'" "1"
fi
