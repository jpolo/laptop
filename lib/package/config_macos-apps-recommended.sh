#!/usr/bin/env bash

laptop_require "laptop_defaults_ensure"

laptop_package_ensure__config:macos-apps-recommended() {
  # Disable slack auto update (will be updated with brew upgrade / brew auto upgrade)
  laptop_defaults_ensure com.tinyspeck.slackmacgap AutoUpdate -bool false
}
