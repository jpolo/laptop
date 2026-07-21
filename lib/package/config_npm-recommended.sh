#!/usr/bin/env bash

laptop_require "laptop_npm_config_ensure"

laptop_package_ensure__config:npm-recommended() {
  # login logic moved to logic command
  true
}
