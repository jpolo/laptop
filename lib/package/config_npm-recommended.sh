#!/usr/bin/env bash

laptop_require "laptop_npm_config_ensure"

laptop_package_ensure__config:npm-recommended() {
  # Login using GITHUB_TOKEN to npm github npm.pkg.github.com
  # shellcheck disable=SC2016
  laptop_shell_ensure_var "$HOME/.profile" "GITHUB_TOKEN" '"\$(GITHUB_TOKEN= gh auth token 2>/dev/null)"'

  # Keep variable references in .npmrc so token updates do not require rewrites.
  # shellcheck disable=SC2016
  laptop_npm_config_ensure "//npm.pkg.github.com/:_authToken" '${GITHUB_TOKEN}'
}
