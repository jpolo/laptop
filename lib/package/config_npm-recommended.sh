#!/usr/bin/env bash

laptop_require "laptop_npm_config_ensure"

laptop_package_ensure__config:npm-recommended() {

  # Keep variable references in .npmrc so token updates do not require rewrites.
  laptop_npm_config_ensure "//npm.pkg.github.com/:_authToken" '${GITHUB_TOKEN}'
  laptop_npm_config_ensure "//registry.npmjs.org/:_authToken" '${NPM_TOKEN}'
}
