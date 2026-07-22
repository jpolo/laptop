#!/usr/bin/env bash

laptop_require "laptop_command_exists"
laptop_require "laptop_directory_ensure"
laptop_require "laptop_package_ensure"

laptop_package_ensure__config:os-recommended() {

  # Ensure Code directory
  laptop_directory_ensure "$HOME/Code"
  # Ensure Captures directory (instead of Desktop)
  laptop_directory_ensure "$HOME/Captures"

  if laptop_command_exists "defaults"; then
    laptop_package_ensure "config:macos-global-recommended"
    laptop_package_ensure "config:macos-screencapture-recommended"
    laptop_package_ensure "config:macos-update-recommended"
    laptop_package_ensure "config:macos-apps-recommended"
  fi
}
