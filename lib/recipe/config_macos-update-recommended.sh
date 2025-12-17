#!/usr/bin/env bash

laptop_require "laptop_defaults_ensure"

laptop_package_ensure__config:macos-update-recommended() {
  # Software updates recommended

  # This will enable automatic updates for macOS and software updates

  # Enable the automatic update check
  laptop_defaults_ensure com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
  # Download newly available updates in background
  laptop_defaults_ensure com.apple.SoftwareUpdate AutomaticDownload -int 1
  # Install System data files & security updates
  laptop_defaults_ensure com.apple.SoftwareUpdate CriticalUpdateInstall -int 1
  # Automatically download apps purchased on other Macs
  laptop_defaults_ensure com.apple.SoftwareUpdate ConfigDataInstall -int 1
  # Turn on app auto-update
  laptop_defaults_ensure com.apple.commerce AutoUpdate -bool true
}
